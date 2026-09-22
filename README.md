# 一加 Ace 6T (PLR110 / SM8845) 内核编译工具

## 这是什么

一套 GitHub Actions 自动编译脚本，帮你在线编译一加 Ace 6T 的自定义内核，不需要本地编译环境。

## 怎么用

### 1. 创建 GitHub 仓库

1. 打开 https://github.com/new
2. 仓库名随便填（比如 `ace6t-kernel`）
3. 选择 **Private**（私有）或 **Public**（公开）
4. 点击 **Create repository**

### 2. 上传文件

把这个文件夹里的所有文件上传到你刚创建的仓库：

- `.github/workflows/build.yml` — 编译工作流
- `AnyKernel3/anykernel.sh` — 刷入脚本
- `README.md` — 本说明

可以用网页上传：点 **Add file → Upload files**，把文件拖进去。

### 3. 开启 Actions

1. 进入仓库的 **Actions** 标签页
2. 点击 **"I understand my workflows, go ahead and enable them"**
3. 左侧应该能看到 **"Build Kernel for OP-ACE-6T"**

### 4. 开始编译

1. 点击 **Build Kernel for OP-ACE-6T**
2. 点击右侧 **Run workflow** 按钮
3. 选择参数：
   - **ksu_branch**: `next`（带 root）或 `none`（不带 root）
   - **manifest_branch**: 留空自动检测
4. 点击绿色 **Run workflow** 按钮
5. 等待编译完成（约 30-60 分钟）

### 5. 下载编译产物

1. 编译完成后，点进那次运行记录
2. 拉到最下面 **Artifacts** 区域
3. 下载 `OP-ACE-6T-Kernel.zip`
4. 解压后得到 `OP-ACE-6T-SM8845-KernelSU-xxx.zip`

### 6. 刷入手机

1. 把 zip 传到手机
2. 进入 TWRP / Recovery
3. 刷入这个 zip
4. 重启（首次启动较慢，耐心等 5-10 分钟）

## 带什么功能

- KernelSU Next（root 权限管理）
- BBR TCP 加速
- Netfilter / NAT 支持
- 标准 GKI 内核配置

## 注意事项

1. **先备份 boot 分区**！刷内核有变砖风险
2. 首次启动会很慢，正常现象
3. 如果编译失败，看 Actions 日志找原因
4. 每次编译大概消耗 GitHub Actions 免费额度
   - 免费账号：2000 分钟/月
   - 一次编译约 30-60 分钟

## 文件说明

```
ace6t-kernel-builder/
├── .github/
│   └── workflows/
│       └── build.yml          # GitHub Actions 编译脚本
├── AnyKernel3/
│   └── anykernel.sh           # 刷入脚本配置
└── README.md                  # 本文件
```

## 常见问题

**Q: 编译失败怎么办？**
A: 看 Actions 日志里的红色错误，截图发我帮你看。

**Q: manifest_branch 填什么？**
A: 留空自动检测。如果自动检测失败，手动填类似 `oneplus/sm8845_b_16.0.0_xxxx` 的分支名。

**Q: 编译出来的内核能直接用吗？**
A: 理论上可以，但 GKI 内核编译经常有各种小问题，需要多试几次或调整参数。

**Q: 为什么不直接用 WildKernels 的现成版本？**
A: 如果你只是要 root，直接刷 WildKernels 的现成 zip 最省事。自己编译是为了加自定义功能或改配置。
