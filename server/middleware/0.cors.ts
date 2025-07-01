export default eventHandler((event) => {
  // Only handle CORS for API endpoints
  if (!event.path.startsWith('/api/')) {
    return
  }

  const { corsOrigins, corsEnabled } = useRuntimeConfig(event)

  // Skip CORS if disabled
  if (!corsEnabled) {
    return
  }

  const origin = getHeader(event, 'origin')
  const allowedOrigins = corsOrigins ? corsOrigins.split(',').map(o => o.trim()) : ['*']

  // Set CORS headers
  if (allowedOrigins.includes('*') || (origin && allowedOrigins.includes(origin))) {
    setHeader(event, 'Access-Control-Allow-Origin', allowedOrigins.includes('*') ? '*' : origin)
  }

  setHeader(event, 'Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
  setHeader(event, 'Access-Control-Allow-Headers', 'Content-Type, Authorization, X-Requested-With')
  setHeader(event, 'Access-Control-Allow-Credentials', 'true')
  setHeader(event, 'Access-Control-Max-Age', '86400') // 24 hours

  // Handle preflight requests
  if (getMethod(event) === 'OPTIONS') {
    setResponseStatus(event, 200)
    return ''
  }
})
