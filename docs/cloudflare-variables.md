# Cloudflare 必需配置变量

在Cloudflare上部署Sink时，需要配置以下变量和服务。

## 🔧 必需的Cloudflare服务配置

### 1. **KV Namespace** (必需)
这是最重要的配置，用于存储短链数据。

**步骤：**
1. 在Cloudflare Dashboard中，进入 **Storage & Databases** → **KV**
2. 创建一个新的KV namespace（例如：`sink-kv`）
3. 复制生成的Namespace ID
4. 在 `wrangler.jsonc` 中更新：
```json
{
  "kv_namespaces": [
    {
      "binding": "KV",
      "id": "你的KV-namespace-ID"  // 替换这里
    }
  ]
}
```

### 2. **Analytics Engine Dataset** (可选，用于统计)
用于收集访问统计数据。

**步骤：**
1. 在Cloudflare Dashboard中启用Analytics Engine
2. 确保 `wrangler.jsonc` 中的配置正确：
```json
{
  "analytics_engine_datasets": [
    {
      "binding": "ANALYTICS",
      "dataset": "sink"
    }
  ]
}
```

## 🔑 必需的环境变量

### 基础必需变量

#### `NUXT_SITE_TOKEN` (必需)
- **用途**: API认证令牌，用于访问管理面板和API
- **要求**: 至少8个字符
- **默认值**: `SinkCool`
- **示例**: `MySecureToken123`

### 统计功能必需变量 (如果需要统计功能)

#### `NUXT_CF_ACCOUNT_ID` (统计功能必需)
- **用途**: Cloudflare账户ID，用于Analytics Engine
- **获取方式**: [查找账户ID](https://developers.cloudflare.com/fundamentals/setup/find-account-and-zone-ids/)
- **示例**: `1234567890abcdef1234567890abcdef`

#### `NUXT_CF_API_TOKEN` (统计功能必需)
- **用途**: Cloudflare API令牌，用于访问Analytics Engine
- **权限要求**: `Account.Account Analytics`
- **创建方式**: [创建API令牌](https://developers.cloudflare.com/fundamentals/api/get-started/create-token/)
- **示例**: `your-cloudflare-api-token`

## 🎛️ 可选的环境变量

### 功能配置
- `NUXT_PUBLIC_PREVIEW_MODE`: 演示模式 (默认: `false`)
- `NUXT_PUBLIC_SLUG_DEFAULT_LENGTH`: 默认slug长度 (默认: `6`)
- `NUXT_REDIRECT_STATUS_CODE`: 重定向状态码 (默认: `301`)
- `NUXT_CASE_SENSITIVE`: 是否区分大小写 (默认: `false`)

### CORS配置 (我们已添加)
- `NUXT_CORS_ENABLED`: 启用CORS (默认: `true`)
- `NUXT_CORS_ORIGINS`: 允许的源域名 (默认: `*`)

### 缓存和性能
- `NUXT_LINK_CACHE_TTL`: 链接缓存时间 (默认: `60`秒)
- `NUXT_REDIRECT_WITH_QUERY`: 重定向时保留查询参数 (默认: `false`)

### AI功能 (可选)
- `NUXT_AI_MODEL`: AI模型名称 (默认: `@cf/meta/llama-3.1-8b-instruct`)
- `NUXT_AI_PROMPT`: AI提示词

## 📋 配置步骤

### Cloudflare Workers部署
1. **在Workers Dashboard中设置环境变量**:
   - 进入你的Worker项目
   - **Settings** → **Variables and Secrets**
   - 添加以下变量：

```bash
# 必需
NUXT_SITE_TOKEN=YourSecureToken123

# 如果需要统计功能
NUXT_CF_ACCOUNT_ID=your-account-id
NUXT_CF_API_TOKEN=your-api-token

# 可选
NUXT_CORS_ENABLED=true
NUXT_CORS_ORIGINS=https://yourdomain.com
```

### Cloudflare Pages部署
1. **在Pages项目中设置环境变量**:
   - 进入你的Pages项目
   - **Settings** → **Environment variables**
   - 分别在 **Production** 和 **Preview** 环境中添加变量

2. **构建设置**:
   - **Build command**: `pnpm run build`
   - **Build output directory**: `dist`
   - **Root directory**: `/`

## ⚠️ 重要注意事项

### 1. KV Namespace配置
- **最常见的500错误原因**就是KV namespace配置错误
- 确保 `wrangler.jsonc` 中的KV namespace ID是正确的
- KV binding名称必须是 `KV`（大写）

### 2. 环境变量优先级
- Cloudflare环境变量会覆盖 `nuxt.config.ts` 中的默认值
- `NUXT_PUBLIC_` 前缀的变量需要在构建时和运行时都设置

### 3. 权限要求
- API Token需要 `Account.Account Analytics` 权限
- 确保Account ID和API Token匹配

## 🔍 验证配置

### 检查KV配置
```bash
# 使用wrangler CLI检查
wrangler kv:namespace list
```

### 测试API
```bash
curl -X POST https://your-domain.com/api/link/create \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YourSiteToken" \
  -d '{"url":"https://example.com"}'
```

### 检查环境变量
在Worker中添加临时日志：
```javascript
console.log('Environment check:', {
  hasKV: !!env.KV,
  hasAnalytics: !!env.ANALYTICS,
  siteToken: !!env.NUXT_SITE_TOKEN
});
```

## 🆘 故障排除

如果遇到问题，请检查：
1. KV namespace ID是否正确
2. 环境变量是否正确设置
3. API Token权限是否足够
4. 域名绑定是否正确

更多故障排除信息，请参考 [troubleshooting-500.md](./troubleshooting-500.md)。
