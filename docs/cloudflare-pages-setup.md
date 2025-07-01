# Cloudflare Pages 部署必需配置

专门针对Cloudflare Pages部署的完整配置指南。

## 🚀 部署步骤概览

### 第一阶段：基础部署
1. Fork项目到你的GitHub账户
2. 在Cloudflare Pages创建项目
3. 配置基础环境变量
4. 首次部署（会失败，这是正常的）

### 第二阶段：服务绑定
5. 取消部署，配置服务绑定
6. 设置兼容性标志
7. 重新部署

## 📋 详细配置步骤

### 步骤1：创建Cloudflare Pages项目
1. 进入 [Cloudflare Pages](https://dash.cloudflare.com/pages)
2. 点击 **Create a project**
3. 选择你Fork的 `Sink` 仓库
4. 选择 **Nuxt.js** 预设

### 步骤2：配置环境变量
在 **Settings** → **Environment variables** 中添加：

#### 🔴 必需的环境变量

```bash
# 基础认证（必需）
NUXT_SITE_TOKEN=YourSecureToken123  # 至少8个字符，不能是纯数字

# 如果需要统计功能（推荐）
NUXT_CF_ACCOUNT_ID=your-account-id
NUXT_CF_API_TOKEN=your-api-token

# CORS支持（已添加，可选配置）
NUXT_CORS_ENABLED=true
NUXT_CORS_ORIGINS=*  # 或指定域名，如 https://yourdomain.com
```

#### 🟡 可选的环境变量

```bash
# 功能配置
NUXT_PUBLIC_PREVIEW_MODE=false
NUXT_PUBLIC_SLUG_DEFAULT_LENGTH=6
NUXT_REDIRECT_STATUS_CODE=301
NUXT_CASE_SENSITIVE=false
NUXT_LINK_CACHE_TTL=60
NUXT_REDIRECT_WITH_QUERY=false
NUXT_HOME_URL=https://yourdomain.com

# AI功能（可选）
NUXT_AI_MODEL=@cf/meta/llama-3.1-8b-instruct
```

**重要**: 
- 在 **Production** 和 **Preview** 环境中都要添加这些变量
- `NUXT_PUBLIC_` 前缀的变量需要在构建时设置

### 步骤3：首次部署
1. 点击 **Save and Deploy**
2. 部署会失败（这是正常的，因为还没有配置服务绑定）

### 步骤4：配置服务绑定
部署失败后，进入 **Settings** → **Bindings** → **Add**：

#### 🔴 必需的绑定

##### KV Namespace（最重要）
1. 先创建KV namespace：
   - 进入 **Storage & Databases** → **KV**
   - 点击 **Create a namespace**
   - 命名为 `sink-kv`（或其他名称）
   - 复制生成的 Namespace ID

2. 在Pages项目中添加KV绑定：
   - **Variable name**: `KV`（必须大写）
   - **KV namespace**: 选择刚创建的namespace

#### 🟡 可选的绑定

##### Analytics Engine（用于统计）
1. 启用Analytics Engine：
   - 在 **Workers & Pages** 右侧面板找到 **Analytics Engine**
   - 点击 **Set up** 启用免费版

2. 添加Analytics绑定：
   - **Variable name**: `ANALYTICS`
   - **Dataset**: `sink`

##### Workers AI（用于AI功能）
- **Variable name**: `AI`
- 选择 **Workers AI Catalog**

### 步骤5：设置兼容性标志
进入 **Settings** → **Runtime** → **Compatibility flags**：
- 添加标志: `nodejs_compat`

### 步骤6：重新部署
1. 进入 **Deployments**
2. 点击 **Retry deployment** 或触发新的部署

## 🔍 获取必需信息

### Cloudflare Account ID
1. 进入Cloudflare Dashboard
2. 右侧边栏可以看到 **Account ID**
3. 复制这个ID

### Cloudflare API Token
1. 进入 [API Tokens页面](https://dash.cloudflare.com/profile/api-tokens)
2. 点击 **Create Token**
3. 使用 **Custom token** 模板
4. 设置权限：
   - **Account** - `Account Analytics:Read`
   - **Zone** - `Zone:Read`（如果需要）
5. 复制生成的token

## ⚠️ 常见问题和解决方案

### 问题1：500错误 - KV未配置
**症状**: API返回500状态码
**原因**: KV namespace未正确绑定
**解决**: 
- 检查KV binding名称是否为 `KV`（大写）
- 确认KV namespace已创建并正确绑定

### 问题2：无法登录管理面板
**症状**: 登录时提示token错误
**原因**: `NUXT_SITE_TOKEN` 配置问题
**解决**:
- 确保token至少8个字符
- 不能是纯数字
- 在Production和Preview环境都要设置

### 问题3：统计数据不显示
**症状**: 管理面板中看不到访问统计
**原因**: Analytics Engine未配置
**解决**:
- 确保 `NUXT_CF_ACCOUNT_ID` 和 `NUXT_CF_API_TOKEN` 正确
- 检查Analytics Engine绑定
- 确认API Token有正确权限

### 问题4：CORS错误
**症状**: 跨域请求被阻止
**解决**: 我们已经添加了CORS支持，确保设置：
```bash
NUXT_CORS_ENABLED=true
NUXT_CORS_ORIGINS=*  # 或指定域名
```

## 🧪 验证部署

### 测试API
```bash
curl -X POST https://your-domain.pages.dev/api/link/create \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YourSiteToken" \
  -d '{"url":"https://example.com"}'
```

### 检查管理面板
1. 访问 `https://your-domain.pages.dev/dashboard`
2. 使用你设置的 `NUXT_SITE_TOKEN` 登录
3. 尝试创建短链接

## 📝 最小配置清单

如果你只想要基本功能，最少需要：

1. **环境变量**:
   - `NUXT_SITE_TOKEN=YourToken123`

2. **服务绑定**:
   - KV Namespace (binding名称: `KV`)

3. **兼容性标志**:
   - `nodejs_compat`

这样就可以正常使用短链接创建和重定向功能了！

## 🔄 更新代码

当项目有更新时：
1. 在GitHub上同步你的Fork
2. Cloudflare Pages会自动重新部署
3. 或者手动触发重新部署
