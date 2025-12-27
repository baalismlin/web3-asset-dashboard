# Contracts (Solidity + Hardhat)

该目录包含智能合约代码以及部署、测试脚本。

## 功能

- 编写与部署 ERC20 / 资产相关合约
- 本地 Hardhat 网络部署
- 测试与验证合约逻辑

## 本地开发

### 安装依赖

```bash
npm install
```

### 启动本地 Hardhat 节点

```bash
npx hardhat node
```

### 部署合约

```bash
npx hardhat run scripts/deploy.ts --network localhost
```

### 部署到测试网

确保在 .env 中设置测试网 RPC 和私钥：

```bash
npx hardhat run scripts/deploy.ts --network sepolia
```

## 目录结构

contracts/: Solidity 文件

scripts/: 部署/初始化脚本

test/: 单元测试

hardhat.config.ts: Hardhat 配置

## 注意

部署测试网时请确保余额足够。
