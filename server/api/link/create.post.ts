import { LinkSchema } from '@@/schemas/link'

defineRouteMeta({
  openAPI: {
    description: 'Create a new short link',
    requestBody: {
      required: true,
      content: {
        'application/json': {
          // Need: https://github.com/nitrojs/nitro/issues/2974
          schema: {
            type: 'object',
            required: ['url'],
            properties: {
              url: {
                type: 'string',
                description: 'The URL to shorten',
              },
            },
          },
        },
      },
    },
  },
})

export default eventHandler(async (event) => {
  try {
    // Validate request body
    const link = await readValidatedBody(event, LinkSchema.parse)

    const { caseSensitive } = useRuntimeConfig(event)

    if (!caseSensitive) {
      link.slug = link.slug.toLowerCase()
    }

    // Check Cloudflare context
    const { cloudflare } = event.context
    if (!cloudflare) {
      console.error('Cloudflare context not available')
      throw createError({
        status: 500,
        statusText: 'Cloudflare environment not configured',
      })
    }

    const { KV } = cloudflare.env
    if (!KV) {
      console.error('KV binding not available')
      throw createError({
        status: 500,
        statusText: 'KV storage not configured',
      })
    }

    // Check if link already exists
    const existingLink = await KV.get(`link:${link.slug}`)
    if (existingLink) {
      throw createError({
        status: 409, // Conflict
        statusText: 'Link already exists',
      })
    }

    // Create new link
    const expiration = getExpiration(event, link.expiration)

    await KV.put(`link:${link.slug}`, JSON.stringify(link), {
      expiration,
      metadata: {
        expiration,
        url: link.url,
        comment: link.comment,
      },
    })

    setResponseStatus(event, 201)
    const shortLink = `${getRequestProtocol(event)}://${getRequestHost(event)}/${link.slug}`
    return { link, shortLink }
  }
  catch (error) {
    // Log the error for debugging
    console.error('Error in create link API:', error)

    // If it's already a createError, re-throw it
    if (error.statusCode || error.status) {
      throw error
    }

    // For unexpected errors, return 500
    throw createError({
      status: 500,
      statusText: 'Internal server error',
      data: process.env.NODE_ENV === 'development' ? error.message : undefined,
    })
  }
})
