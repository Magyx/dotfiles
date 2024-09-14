import { applauncher } from "./modules/applauncher";
import { Bar as bar } from "./modules/bar";
// import { NotificationPopups } from "./modules/notifications";
// import { Media } from "./modules/player";
// import { Wallpaper } from "./modules/wallpaper";
// import { Dock, dockActivator } from "./modules/dock";

App.config({
  windows: [
    bar(),
    applauncher,
  ],
});
