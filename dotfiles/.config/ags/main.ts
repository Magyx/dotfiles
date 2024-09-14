import { applauncher } from "./modules/applauncher.js";
import { Bar as bar } from "./modules/bar.js";
// import { NotificationPopups } from "./modules/notifications.js";
// import { Media } from "./modules/player.js";
// import { Wallpaper } from "./modules/wallpaper.js";
// import { Dock, dockActivator } from "./modules/dock.js";

App.config({
  windows: [
    bar(),
    applauncher,
  ],
});
