# Backend (Node.js + TypeScript + Express)

该目录为 Web3 后端服务。

## 功能

- 链上数据调用（Ethers.js）
- 钱包签名验证
- 合约写入逻辑
- 提供 REST API

## 本地开发

### 安装依赖

```bash
npm install
```

### 环境变量

```env
创建 .env：
PORT=3001
RPC_URL=http://127.0.0.1:8545
PRIVATE_KEY=<你的私钥>
```

### 启动服务

```bash
npm run dev
```

开发模式支持热重载。
