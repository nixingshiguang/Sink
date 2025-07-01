export default eventHandler((event) => {
  // Only handle CORS for API endpoints
  if (!event.path.startsWith('/api/')) {
    return
  }

  try {
    const { corsOrigins, corsEnabled } = useRuntimeConfig(event)

    // Skip CORS if disabled
    if (!corsEnabled) {
      return
    }

    const origin = getHeader(event, 'origin')
    const allowedOrigins = corsOrigins ? corsOrigins.split(',').map(o => o.trim()) : ['*']

    // Set CORS headers based on configuration
    const allowOrigin = allowedOrigins.includes('*') ? '*' : (origin && allowedOrigins.includes(origin) ? origin : '*')

    setHeader(event, 'Access-Control-Allow-Origin', allowOrigin)
    setHeader(event, 'Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
    setHeader(event, 'Access-Control-Allow-Headers', 'Content-Type, Authorization, X-Requested-With')
    setHeader(event, 'Access-Control-Allow-Credentials', 'true')
    setHeader(event, 'Access-Control-Max-Age', '86400') // 24 hours

    // Handle preflight requests
    if (getMethod(event) === 'OPTIONS') {
      setResponseStatus(event, 200)
      return ''
    }
  }
  catch (error) {
    // If there's any error in CORS processing, log it but don't break the request
    console.error('CORS middleware error:', error)
  }
})
