import { loadCompositor } from "../utils/compositor";

const notifications = await Service.import("notifications");
const mpris = await Service.import("mpris");
const audio = await Service.import("audio");
const battery = await Service.import("battery");
const systemtray = await Service.import("systemtray");

const date = Variable("", {
    poll: [1000, 'date "+%a %e %b %H:%M"'],
})

function Workspaces() {
    let workspaces = {};
    loadCompositor()
        .then(module => {
            const compositor = new(module.Hyprland || module.Sway)();
            console.log(compositor.constructor.name);
            switch (compositor.constructor.name) {
                case 'Hyprland':
                    const hyprActiveId = compositor.active.workspace.bind("id")
                    workspaces = compositor.bind("workspaces").as(ws =>
                        ws.map(({ id }) => Widget.Button({
                            on_clicked: () => hyprland.messageAsync(`dispatch workspace ${id}`),
                            child: Widget.Label(`${id}`),
                            class_name: hyprActiveId.as(i => `${i === id ? "focused" : ""}`),
                        }))
                    );
                    break;

                case 'Sway':
                    const swayActiveId = compositor.active.workspace.bind("id");
                    workspaces = compositor.bind("workspaces").as(ws =>
                        ws.map(({ id }) =>
                        Widget.Button({
                           on_clicked: () => compositor.messageAsync(`workspace ${id}`),
                           child: Widget.label(`${id}`),
                           class_name: swayActiveId.as(i => `${i === id ? "focused" : ""}`),
                        }))
                    );
                    break;

                default:
                    console.log('No workspace support.');
            }
        })
        .catch(error => console.error('Error loading compositor:', error));

    return Widget.Box({
        class_name: "workspaces",
        children: workspaces,
    })
}


function Clock() {
    return Widget.Label({
        class_name: "clock",
        label: date.bind(),
    })
}


function SysTray() {
    const items = systemtray.bind("items")
        .as(items => items.map(item => Widget.Button({
            child: Widget.Icon({ icon: item.bind("icon") }),
            on_primary_click: (_, event) => item.activate(event),
            on_secondary_click: (_, event) => item.openMenu(event),
            tooltip_markup: item.bind("tooltip_markup"),
        })))

    return Widget.Box({
        children: items,
    })
}


// layout of the bar
function Left() {
    return Widget.Box({
        spacing: 8,
        children: [
            Workspaces(),
        ],
    })
}

function Center() {
    return Widget.Box({
        spacing: 8,
        children: [
            Clock(),
        ],
    })
}

function Right() {
    return Widget.Box({
        hpack: "end",
        spacing: 8,
        children: [
            SysTray(),
        ],
    })
}

export function Bar(monitor = 0) {
    return Widget.Window({
        name: `bar-${monitor}`, // name has to be unique
        class_name: "bar",
        monitor,
        anchor: ["top", "left", "right"],
        exclusivity: "exclusive",
        child: Widget.CenterBox({
            start_widget: Left(),
            center_widget: Center(),
            end_widget: Right(),
        }),
    })
}
