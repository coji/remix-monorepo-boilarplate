/** @type {import('@remix-run/dev').AppConfig} */
module.exports = {
  ignoredRouteFiles: ['**/.*'],
  future: {
    v2_errorBoundary: true,
    v2_meta: true,
    v2_normalizeFormMethod: true,
    v2_routeConvention: true,
  },
  devServerPort: 8001,
  serverModuleFormat: 'cjs',
  watchPaths: ['node_modules/database', 'node_modules/ui'],
}
