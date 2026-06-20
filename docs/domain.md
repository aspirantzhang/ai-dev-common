# 领域语义

- 候选人 Candidate：尚未完成入职的人员。前端可称为“候选人”或“待入职人员”，后端领域统一使用 Candidate。
- 员工 Employee：已完成入职并进入员工主档的人员。候选人完成入职后才会创建或绑定 Employee。
- 入职 Onboarding：候选人转员工的业务流程，通常会同时生成员工主档、任职信息、账号、考勤档案和薪资档案。
- 离职 Offboarding：员工结束任职关系的业务流程，不等同于删除员工数据；通常会影响账号、考勤、薪酬、绩效和交接状态。
- 组织单元 OrganizationUnit：部门、团队、成本中心等组织结构节点。涉及历史归属时必须考虑生效日期。
- 岗位 Position：员工任职角色和岗位等级，不直接等同于系统权限。
- 薪资主体 PayrollEntity：用于区分不同发薪、税务或核算主体。
- 用工类型 EmploymentType：描述员工与组织的用工关系，如正式、实习、外包、顾问。
- 字典值输出统一使用 `${原字段名}_name` 辅助字段，字典 label 通过统一 helper 获取，例如 `getDictionaryLabel('employment_type', value)`。
- 字典全量数据通过共享字典服务获取，例如 `src/modules/dictionary`，不要在页面或业务服务中重复维护枚举文案。
- 用工类型示例值

```
{
    "value": "full_time",
    "label": "正式员工"
},
{
    "value": "intern",
    "label": "实习生"
},
{
    "value": "contractor",
    "label": "外包人员"
},
{
    "value": "consultant",
    "label": "顾问"
}
```

- 在业务中，经常对用工类型进行分组管理
  - 内部受薪人员：`full_time`, `intern`
  - 外部协作人员：`contractor`, `consultant`
