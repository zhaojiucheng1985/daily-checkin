# 日常

一个离线优先的个人坚持记录系统：每日打卡、成果备注、跑量统计、周期汇总、阳历/农历生日和重要日期提醒。

## 本地运行

直接用浏览器打开 `index.html` 即可；或在项目目录执行：

```powershell
npx serve .
```

未登录时，数据保存在当前浏览器的 LocalStorage。请在「设置 → 数据管理」定期导出 JSON 备份。

## 使用 Supabase 跨设备同步

项目已经包含登录和自动同步功能。每个账号只会读取和写入自己的数据；本地数据也会保留，网络暂时不可用时仍可继续使用。

1. 在 Supabase 项目的 **SQL Editor** 打开并执行 [`supabase-schema.sql`](supabase-schema.sql)，创建数据表和访问权限。
2. 打开 Supabase 的 **Project Settings → API**，复制 `Project URL` 和 `publishable key`（旧项目中也可能显示为 `anon public` key）。不要使用或提交 `service_role` key。
3. 将这两项填写到 [`supabase-config.js`](supabase-config.js)：

   ```js
   window.SUPABASE_CONFIG = {
     url: 'https://你的项目.supabase.co',
     publishableKey: '你的 publishable key'
   };
   ```

4. 在 Supabase 的 **Authentication → Providers → Email** 确认已开启邮箱登录。若启用“Confirm email”，注册后需要先在邮箱中完成验证。
5. 在 **Authentication → URL Configuration** 配置回跳地址：
   - 发布到 GitHub Pages 后，将 `Site URL` 设为 `https://zhaojiucheng1985.github.io/daily-checkin/`；
   - 在 `Redirect URLs` 中添加 `https://zhaojiucheng1985.github.io/daily-checkin/**`；
   - 本地调试时，如使用本地服务器，可额外添加 `http://localhost:3000/**`。
6. 打开页面右上角的「登录同步」，注册或登录相同的邮箱账号。另一台电脑打开同一网址并登录该账号后，就会下载同一份数据。

`supabase-config.js` 中的 Project URL 和 publishable/anon key 是给浏览器使用的公开配置，可以随 GitHub Pages 发布；真正保护数据的是 SQL 中的 RLS 规则。绝不能将 `service_role` key 放进前端或 GitHub。

## 说明

- 默认任务已按照需求预置，可在设置页新增、编辑或删除。
- 每日卡片可勾选或填写数量、成果和备注；跑步自动累计到当月。
- 汇总页可切换每天、每周、每月趋势；日历可回填过往日期。
- 重要提醒支持一次性、每年阳历和每年农历。农历匹配使用浏览器内置的中文农历国际化日历；现代 Chrome/Edge 均支持。
- 准备公开到 GitHub 时，可直接启用 GitHub Pages 托管此静态站点；个人数据会存放在 Supabase，不会提交到仓库。

## 参考

本项目保持为无依赖的单页静态应用。若未来需要复杂的拖拽日历，可接入 [FullCalendar](https://github.com/fullcalendar/fullcalendar)；农历转换可升级为 [lunar-javascript](https://github.com/6tail/lunar-javascript)（MIT），以支持更丰富的节气与闰月规则。
