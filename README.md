# 🔍 VulnTrace · 攻击流量特征靶场

> 专注于网络攻击类流量特征分析与检测训练的开源靶场项目，由 [crow](https://github.com/crow821) 发起并维护。

---

# 项目还在更新中，敬请期待！

# TODO：

## 📌 项目简介-更新中，暂未开放

**VulnTrace** 是一个以 A-Z 字母顺序为主线，收录当前主流攻击工具（如 AntSword、SQLMap、Cobalt Strike 等）的网络流量特征，并提供对应的：

- 📦 **流量样本（pcap）**
- 📖 **详细分析文档**
- 🧪 **可复现的 docker 靶场环境（部分可选）**
- ✅ **可验证的检测练习题**

本项目致力于帮助红队、蓝队、安全研究人员理解攻击行为背后的网络痕迹，提升检测与应对能力。

---

## 🧠 项目目标

- ⛓️ **重现攻击工具真实流量行为**
- 🔍 **分析其流量特征与模式**
- 🛡️ **辅助规则编写与检测模型训练**
- 🎯 **为攻防演练/CTF 提供训练材料**

---

## 🗂️ 项目结构

```bash
vulntrace/
├── pcaps/          # 攻击流量包（PCAP格式）
│   ├── antsword/
│   ├── sqlmap/
│   └── ...
├── docs/           # 每个工具对应的流量分析文档（Markdown）
│   ├── antsword.md
│   ├── sqlmap.md
│   └── ...
├── docker/         # 可选的docker复现环境（含 vulnerable app + 攻击脚本）
├── tasks/          # 针对每个pcap的分析任务（适合学习、考试、演练）
└── tools/          # 外部工具说明及使用指南（不包含攻击工具本体）
```





## 🧪 已支持工具（持续更新中）

| 工具名          | 类型          | 流量特征 | 分析状态  |
| ------------ | ----------- | ---- | ----- |
| AntSword     | WebShell C2 | ✅    | ✅ 已发布 |
| Behinder     | WebShell C2 | ✅    | ✅ 已发布 |
| SQLMap       | 注入工具        | ✅    | ✅ 已发布 |
| Dirbuster    | 爆破工具        | ✅    | ⏳ 处理中 |
| CobaltStrike | C2框架        | ✅    | ⏳ 处理中 |
| Gobuster     | 目录爆破        | ✅    | ✅ 已发布 |
| Fscan        | 资产探测工具      | ✅    | ⏳ 待补充 |
| ...          | ...         | ...  | ...   |

📌 欢迎贡献新工具流量包与文档，共建更完整的攻击画像特征库！

---

## 🖥️ 如何使用

### 1. 直接学习分析

```bash
# 下载项目
git clone https://github.com/crow821/vulntrace.git
cd vulntrace

# 打开某个工具分析文档
less docs/sqlmap.md

# 使用 Wireshark 打开对应流量包
wireshark pcaps/sqlmap/sqlmap-timebased.pcap
```

### 2. 复现攻击流量

```bash
# 进入复现环境目录
cd docker/sqlmap-lab

# 构建靶场环境
docker-compose up -d

# 手动运行工具生成流量
bash run-sqlmap.sh

# 抓包 & 分析
```

---

## 🧑‍🎓 适用人群

* 安全初学者：理解攻击流量的基本结构
* 安全工程师：提取攻击检测特征
* 威胁研究员：制作检测规则 / IDS 规则
* SOC / 蓝队：训练实战流量识别能力

---

## 🛠️ 环境依赖建议

* 推荐使用 [Wireshark](https://www.wireshark.org/) 进行分析
* 若需要自动检测特征，可尝试 YARA、Suricata 等工具结合使用
* 所有复现环境基于 `docker-compose`

---

## 🤝 加入我们 / 贡献

我们欢迎所有安全研究员与开发者参与：

* 提交新的工具流量样本
* 撰写分析文档
* 设计可交互任务
* 或提供反馈 / 需求建议

请直接提 PR 或 Issue，或通过邮箱/公众号联系我们。

---

## 📫 联系我们

* 📮 Email: `crow_821#163.com`（请将 # 替换为 @）
* 📢 公众号：**乌鸦安全**

<img src="crowsec.jpg" width="30%" height="30%" />

---

## 📄 License

本项目遵循 [MIT License](./LICENSE)，仅用于学习与研究，**严禁用于任何非法用途**。

---

## ⭐ Star 支持我们！

你可以通过 GitHub Star 支持该项目持续更新 👇
[https://github.com/crow821/vulntrace](https://github.com/crow821/vulntrace)
