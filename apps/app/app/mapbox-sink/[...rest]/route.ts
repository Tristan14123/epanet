import { NextResponse } from "next/server";

export const dynamic = "force-dynamic";

/**
 * Token-free mode: mapbox-gl keeps sending telemetry / map-session calls.
 * `mapboxgl.config.API_URL` is pointed here (see src/map/map-canvas.tsx) so
 * no data leaves the machine. Always answer 204 so the console stays clean.
 */
function sink() {
  return new NextResponse(null, { status: 204 });
}

export async function GET() {
  return sink();
}

export async function POST() {
  return sink();
}
