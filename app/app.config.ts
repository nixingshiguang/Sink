export default defineAppConfig({
  title: 'Sink',
  email: 'admin@160621.xyz',
  github: 'https://github.com/ccbikai/sink',
  twitter: '',
  telegram: '',
  mastodon: '',
  blog: 'https://blog.160621.xyz',
  description: 'A Simple / Speedy / Secure Link Shortener with Analytics, 100% run on Cloudflare.',
  image: 'https://sink.cool/banner.png',
  previewTTL: 300, // 5 minutes
  slugRegex: /^[a-z0-9]+(?:-[a-z0-9]+)*$/i,
  reserveSlug: [
    'dashboard',
  ],
})
