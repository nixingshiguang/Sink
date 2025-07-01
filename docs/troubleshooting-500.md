# 解决API返回500错误的问题

当通过API创建短链时遇到500状态码，通常是由以下几个原因造成的：

## 1. Cloudflare KV配置问题

### 开发环境
在本地开发环境中，Sink使用NuxtHub提供的本地KV存储模拟。如果遇到500错误：

```bash
# 确保已安装依赖
pnpm install

# 启动开发服务器
pnpm dev
```

### 生产环境
在Cloudflare Workers部署时，需要正确配置KV namespace：

1. 在Cloudflare Dashboard中创建KV namespace
2. 在`wrangler.jsonc`中配置KV绑定：
```json
{
  "kv_namespaces": [
    {
      "binding": "KV",
      "id": "your-kv-namespace-id"
    }
  ]
}
```

## 2. 环境变量配置

确保以下环境变量正确设置：

### 必需的环境变量
- `NUXT_SITE_TOKEN`: API认证令牌（默认：SinkCool）

### 可选的环境变量
- `NUXT_CORS_ENABLED`: 是否启用CORS（默认：true）
- `NUXT_CORS_ORIGINS`: 允许的源域名（默认：*）
- `NUXT_CASE_SENSITIVE`: 是否区分大小写（默认：false）

### 设置环境变量
```bash
# 开发环境 (.env)
NUXT_SITE_TOKEN=YourCustomToken
NUXT_CORS_ENABLED=true
NUXT_CORS_ORIGINS=https://yourdomain.com

# Cloudflare Workers
# 在Cloudflare Dashboard的Workers设置中添加环境变量
```

## 3. 请求格式检查

确保API请求格式正确：

### 正确的请求格式
```javascript
const response = await fetch('/api/link/create', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer SinkCool'
  },
  body: JSON.stringify({
    url: 'https://example.com',
    slug: 'optional-custom-slug', // 可选
    comment: 'Optional comment',   // 可选
    expiration: 1234567890        // 可选，Unix时间戳
  })
});
```

### 常见错误
- ❌ 缺少`Content-Type: application/json`头
- ❌ 缺少`Authorization`头
- ❌ 使用错误的认证令牌
- ❌ 发送无效的JSON格式
- ❌ URL格式不正确
- ❌ slug包含非法字符

## 4. 数据验证错误

API使用Zod进行数据验证，以下情况会导致400错误（而非500）：

- URL格式无效
- slug不符合正则表达式规则
- expiration时间戳是过去的时间
- 字段长度超过限制

## 5. 调试步骤

### 步骤1：检查服务器日志
```bash
# 开发环境
pnpm dev
# 查看控制台输出的错误信息

# 生产环境
# 在Cloudflare Dashboard的Workers日志中查看
```

### 步骤2：使用调试脚本
运行提供的调试脚本：
```bash
powershell -ExecutionPolicy Bypass -File debug-500.ps1
```

### 步骤3：测试基本功能
```bash
# 测试简单的创建请求
curl -X POST http://localhost:3000/api/link/create \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer SinkCool" \
  -d '{"url":"https://github.com/ccbikai/Sink"}'
```

## 6. 常见解决方案

### 解决方案1：重新配置KV
```bash
# 1. 删除现有的KV namespace
# 2. 创建新的KV namespace
# 3. 更新wrangler.jsonc中的namespace ID
# 4. 重新部署
```

### 解决方案2：检查认证令牌
```bash
# 确保使用正确的令牌
# 默认令牌是 "SinkCool"
# 可以通过环境变量 NUXT_SITE_TOKEN 自定义
```

### 解决方案3：清除缓存
```bash
# 开发环境
rm -rf .nuxt .output node_modules/.cache
pnpm install
pnpm dev

# 生产环境
# 重新构建和部署
pnpm build
npx wrangler deploy
```

## 7. 联系支持

如果以上步骤都无法解决问题，请提供以下信息：

1. 完整的错误信息和状态码
2. 请求的URL和请求体
3. 使用的环境（开发/生产）
4. Cloudflare配置截图（如适用）
5. 服务器日志输出

## 8. 相关资源

- [Cloudflare KV文档](https://developers.cloudflare.com/kv/)
- [Cloudflare Workers文档](https://developers.cloudflare.com/workers/)
- [NuxtHub文档](https://hub.nuxt.com/)
- [项目GitHub Issues](https://github.com/ccbikai/Sink/issues)
