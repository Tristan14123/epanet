import { ILayerConfig } from "src/types";

export type LayerConfigTemplate = Pick<
  Extract<ILayerConfig, { type: "XYZ" }>,
  "name" | "url" | "type" | "token" | "opacity" | "isBasemap"
> & {
  thumbnailClass: string;
};

// Token-free XYZ basemaps (no Mapbox token required).
// Attribution is added at style build time in layer-config-adapters.ts.
const xyzDefaults = {
  type: "XYZ",
  token: "",
  isBasemap: true,
} as const;

export const basemaps = {
  monochrome: {
    name: "OSM",
    url: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
    thumbnailClass: "bg-thumbnail-monochrome",
    ...xyzDefaults,
    opacity: 1,
  },
  satellite: {
    name: "Satellite",
    url: "https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}",
    thumbnailClass: "bg-thumbnail-satellite",
    ...xyzDefaults,
    opacity: 1,
  },
  outdoors: {
    name: "OpenTopo",
    url: "https://tile.opentopomap.org/{z}/{x}/{y}.png",
    thumbnailClass: "bg-thumbnail-outdoors",
    ...xyzDefaults,
    opacity: 1,
  },
  streets: {
    name: "Carto Light",
    url: "https://basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png",
    thumbnailClass: "bg-thumbnail-streets",
    ...xyzDefaults,
    opacity: 1,
  },
} as const satisfies Record<string, LayerConfigTemplate>;

export const defaultBasemap = basemaps.monochrome;
