import Gdk from 'gi://Gdk?version=3.0';
import GLib from 'gi://GLib';
import Gio from 'gi://Gio';
import Service from 'resource://com/github/Aylur/ags/service.js';

Gio._promisify(Gio.DataInputStream.prototype, 'read_upto_async');

const XDG_RUNTIME_DIR = GLib.getenv('XDG_RUNTIME_DIR') || '/';

export class ActiveClient extends Service {
    static {
        Service.register(this, {}, {
            'address': ['string'],
            'title': ['string'],
            'class': ['string'],
        });
    }

    private _address = '';
    private _title = '';
    private _class = '';

    get address() { return this._address; }
    get title() { return this._title; }
    get class() { return this._class; }
}

export class ActiveID extends Service {
    static {
        Service.register(this, {}, {
            'id': ['int'],
            'name': ['string'],
        });
    }

    private _id = 1;
    private _name = '';

    get id() { return this._id; }
    get name() { return this._name; }

    update(id: number, name: string) {
        super.updateProperty('id', id);
        super.updateProperty('name', name);
    }
}

export class Actives extends Service {
    static {
        Service.register(this, {}, {
            'client': ['jsobject'],
            'monitor': ['jsobject'],
            'workspace': ['jsobject'],
        });
    }

    private _client = new ActiveClient();
    private _monitor = new ActiveID();
    private _workspace = new ActiveID();

    constructor() {
        super();

        (['client', 'workspace', 'monitor'] as const).forEach(obj => {
            this[`_${obj}`].connect('changed', () => {
                this.notify(obj);
                this.emit('changed');
            });
        });
    }

    get client() { return this._client; }
    get monitor() { return this._monitor; }
    get workspace() { return this._workspace; }
}

export class Sway extends Service {
    static {
        Service.register(this, {
            'event': ['string', 'string'],
            'urgent-window': ['string'],
            'fullscreen': ['boolean'],
        }, {
            'active': ['jsobject'],
            'monitors': ['jsobject'],
            'workspaces': ['jsobject'],
            'clients': ['jsobject'],
        });
    }

    private _active: Actives = new Actives();
    private _monitors: Map<number, Monitor> = new Map();
    private _workspaces: Map<number, Workspace> = new Map();
    private _clients: Map<string, Client> = new Map();
    private _decoder = new TextDecoder();
    private _encoder = new TextEncoder();

    get active() { return this._active; }
    get monitors() { return Array.from(this._monitors.values()); }
    get workspaces() { return Array.from(this._workspaces.values()); }
    get clients() { return Array.from(this._clients.values()); }

    readonly getMonitor = (id: number) => this._monitors.get(id);
    readonly getWorkspace = (id: number) => this._workspaces.get(id);
    readonly getClient = (address: string) => this._clients.get(address);

    readonly getGdkMonitor = (id: number) => {
        const monitor = this._monitors.get(id);
        if (!monitor)
            return null;

        return Gdk.Display.get_default()?.get_monitor_at_point(monitor.x, monitor.y) || null;
    };

    constructor() {
        super();

        // Initial sync for monitors, workspaces, and clients
        this._syncMonitors();
        this._syncWorkspaces();
        this._syncClients();

        // Watch for Sway IPC events
        this._watchSwayIPC();
    }

    private _execSwayCommand(command: string): string {
        try {
            const [success, stdout, stderr] = GLib.spawn_command_line_sync(`swaymsg -t get_${command}`);
            if (!success) {
                console.error(stderr);
                return '';
            }
            return stdout;
        } catch (error) {
            console.error(error);
            return '';
        }
    }

    private _watchSwayIPC() {
        // Use Gio's subprocess to monitor sway IPC events in real time
        const process = new Gio.Subprocess({
            argv: ['swaymsg', '-t', 'subscribe', '["window", "workspace"]'],
            flags: Gio.SubprocessFlags.STDOUT_PIPE
        });
        process.init(null);

        const stdout = new Gio.DataInputStream({
            base_stream: process.get_stdout_pipe()
        });

        this._watchSwayEvents(stdout);
    }

    private _watchSwayEvents(stream: Gio.DataInputStream) {
        stream.read_line_async(0, null, (stream, result) => {
            if (!stream) {
                return console.error('Error reading Sway IPC');
            }

            const [line] = stream.read_line_finish(result);
            if (line) {
                this._onSwayEvent(this._decoder.decode(line));
            }

            // Continue watching for events
            this._watchSwayEvents(stream);
        });
    }

    private async _onSwayEvent(event: string) {
        if (!event) return;

        const parsedEvent = JSON.parse(event);
        const type = parsedEvent.change;

        try {
            switch (type) {
                case 'workspace':
                    await this._syncMonitors();
                    await this._syncWorkspaces();
                    this.notify('workspaces');
                    break;

                case 'window':
                    await this._syncClients();
                    this.notify('clients');
                    break;

                default:
                    break;
            }
        } catch (error) {
            console.error(error.message);
        }

        this.emit('event', type, event);
        this.emit('changed');
    }

    private async _syncMonitors() {
        try {
            const monitors = this._execSwayCommand('outputs');
            const parsedMonitors = JSON.parse(monitors);

            this._monitors.clear();
            parsedMonitors.forEach((monitor: Monitor) => {
                this._monitors.set(monitor.id, monitor);
                if (monitor.activeWorkspace && monitor.activeWorkspace.id) {
                    this._active.monitor.update(monitor.id, monitor.name);
                    this._active.workspace.update(monitor.activeWorkspace.id, monitor.activeWorkspace.name);
                }
            });

            this.notify('monitors');
        } catch (error) {
            console.error(error);
        }
    }

    private async _syncWorkspaces() {
        try {
            const workspaces = this._execSwayCommand('workspaces');
            const parsedWorkspaces = JSON.parse(workspaces);

            this._workspaces.clear();
            parsedWorkspaces.forEach((ws: Workspace) => {
                this._workspaces.set(ws.id, ws);
            });

            this.notify('workspaces');
        } catch (error) {
            console.error(error);
        }
    }

    private async _syncClients() {
        try {
            const windows = this._execSwayCommand('tree');
            const parsedClients = JSON.parse(windows).nodes;

            this._clients.clear();
            parsedClients.forEach((client: Client) => {
                this._clients.set(client.address, client);
            });

            this.notify('clients');
        } catch (error) {
            console.error(error);
        }
    }
}

// Monitor, Workspace, and Client interfaces similar to Hyprland.
export interface Monitor {
    id: number;
    name: string;
    activeWorkspace: {
        id: number;
        name: string;
    };
    x: number;
    y: number;
    width: number;
    height: number;
}

export interface Workspace {
    id: number;
    name: string;
}

export interface Client {
    address: string;
    name: string;
    class: string;
    title: string;
    floating: boolean;
    fullscreen: boolean;
}

export const sway = new Sway();
export default sway;
