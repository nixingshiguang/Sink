# Sink API

Writing API documentation manually can be very laborious, and we will automatically generate documents after the official release of [Nitro's OpenAPI](https://nitro.unjs.io/config#openapi).

This place provides an example of creating a short link API. Other APIs are currently available for viewing through browser developer tools.

## CORS Support

The API supports Cross-Origin Resource Sharing (CORS) to allow requests from web browsers. CORS is enabled by default and can be configured through environment variables:

- `NUXT_CORS_ENABLED`: Set to `false` to disable CORS (default: `true`)
- `NUXT_CORS_ORIGINS`: Comma-separated list of allowed origins, or `*` for all origins (default: `*`)

Example CORS configuration:
```bash
# Allow all origins (default)
NUXT_CORS_ORIGINS=*

# Allow specific origins
NUXT_CORS_ORIGINS=https://example.com,https://app.example.com

# Disable CORS
NUXT_CORS_ENABLED=false
```

## API Reference

### Create Short Link

```http
  POST /api/link/create
```

| Header | Description                |
| :----- | :------------------------- |
| `authorization` | `Bearer SinkCool` |
| `content-type` | `application/json` |

#### Example

```http
  POST /api/link/create
  HEADER authorization: Bearer SinkCool
  HEADER content-type: application/json
  BODY  {
          "url": "https://github.com/ccbikai/Sink/issues/14",
          "slug": "issue14"
        }
```

The BODY data must be JSON.

```http
  RESPONSE 201
  BODY  {
          "link": {
            "id": "xpqhaurv5q",
            "url": "https://github.com/ccbikai/Sink/issues/14",
            "slug": "issue14",
            "createdAt": 1718119809,
            "updatedAt": 1718119809
          }
        }
```

| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `id`     | `string` | This is automatically generated by Sink |
| `url`    | `string`   | This is confirmation of the submitted URL and is required. |
| `slug`  | `string` | This is slug generated by the system, either automatically or from the input (if provided) |
| `createdAt`     | `timestamp` | This is automatically generated with a UNIX Timestamp. |
| `updatedAt`     | `timestamp` | This is automatically generated with a UNIX Timestamp. |

#### JavaScript Example (with CORS)

```javascript
// Create a short link from a web browser
async function createShortLink(url, customSlug = null) {
  const payload = { url };
  if (customSlug) {
    payload.slug = customSlug;
  }

  try {
    const response = await fetch('https://your-sink-domain.com/api/link/create', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer SinkCool'
      },
      body: JSON.stringify(payload)
    });

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    const data = await response.json();
    console.log('Short link created:', data.shortLink);
    return data;
  } catch (error) {
    console.error('Error creating short link:', error);
    throw error;
  }
}

// Usage
createShortLink('https://github.com/ccbikai/Sink', 'my-repo')
  .then(result => console.log(result))
  .catch(error => console.error(error));
```
