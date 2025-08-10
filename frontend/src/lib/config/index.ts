export const IS_DEV_ENABLED = false;
const baseSiteUrl = "https://mafiacaster-frontend.vercel.app/";
const devBaseUrl = "https://fcaa3b33130b.ngrok-free.app";

export const config = {
  siteName: "MafiaCaster",
  baseSiteUrl,
  devBaseUrl,
  IS_DEV_ENABLED,
  resolvedBaseUrl: IS_DEV_ENABLED ? devBaseUrl : baseSiteUrl,
  extendedMetadata: {
    description:
      "MafiaCaster - A fun way of saving money in a game of strategy",
    tags: ["sveltekit", "svelte", "mafiacaster"],
    primaryCategory: "game",
    subtitle: "MafiaCaster MiniApp",
    screenshotUrls: [
      IS_DEV_ENABLED
        ? devBaseUrl + "/hotlink-ok/screenshots/screenshot-1.png"
        : baseSiteUrl + "/hotlink-ok/screenshots/screenshot-1.png",
      IS_DEV_ENABLED
        ? devBaseUrl + "/hotlink-ok/screenshots/screenshot-2.png"
        : baseSiteUrl + "/hotlink-ok/screenshots/screenshot-2.png",
    ],
  },
};
