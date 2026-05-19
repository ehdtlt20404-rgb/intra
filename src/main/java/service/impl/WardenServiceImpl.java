package service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import mapper.WardenMapper;
import service.WardenService;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
@Transactional
public class WardenServiceImpl implements WardenService {

    @Autowired
    private WardenMapper wardenMapper;

    // =========================================================
    // 리더십 - 범주
    // =========================================================

    @Override
    public List<Map<String, Object>> getCategoryList() {
        List<Map<String, Object>> categories = wardenMapper.selectCategoryList();
        for (Map<String, Object> cat : categories) {
            String catId = (String) cat.get("catId");
            cat.put("tasks", wardenMapper.selectTaskList(catId));
        }
        return categories;
    }

    @Override
    public int saveCategory(String title, String dept) {
        return wardenMapper.insertCategory(title, dept);
    }

    @Override
    public int deleteCategory(String catId) {
        return wardenMapper.deleteCategory(catId);
    }

    // =========================================================
    // 리더십 - 중점과제
    // =========================================================

    @Override
    public Map<String, Object> getTaskDetail(String catId, String taskId) {
        Map<String, Object> result = new HashMap<String, Object>();
        result.put("category", nvlMap(wardenMapper.selectCategory(catId)));
        result.put("taskIdx",  wardenMapper.selectTaskIndex(catId, taskId));

        Map<String, Object> task = wardenMapper.selectTask(catId, taskId);
        if (task != null) {
            Map<String, Object> detail = wardenMapper.selectTaskDetail(taskId);
            if (detail == null) detail = new HashMap<String, Object>();
            List<Map<String, Object>> monthsDb = wardenMapper.selectTaskMonths(taskId);
            detail.put("months", buildMonthArray(monthsDb));
            task.put("detail", detail);
        }
        result.put("task", nvlMap(task));
        return result;
    }

    @Override
    public int saveTask(String catId, String title) {
        return wardenMapper.insertTask(catId, title);
    }

    @Override
    public int deleteTask(String catId, String taskId) {
        return wardenMapper.deleteTask(catId, taskId);
    }

    @Override
    public int saveTaskDetail(Map<String, Object> param) {
        String taskId = (String) param.get("taskId");
        int exist = wardenMapper.selectTaskDetailCount(param);
        if (exist > 0) wardenMapper.updateTaskDetail(param);
        else           wardenMapper.insertTaskDetail(param);

        wardenMapper.deleteTaskMonths(taskId);
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> months = (List<Map<String, Object>>) param.get("months");
        if (months != null) {
            for (int i = 0; i < months.size(); i++) {
                Map<String, Object> m = months.get(i);
                if (m != null) {
                    Map<String, Object> mp = new HashMap<String, Object>();
                    mp.put("taskId",   taskId);
                    mp.put("monthNum", i + 1);
                    mp.put("plan",     m.get("plan"));
                    mp.put("result",   m.get("result"));
                    wardenMapper.insertTaskMonth(mp);
                }
            }
        }
        return 1;
    }

    // =========================================================
    // 경영계약 - 성과목표
    // =========================================================

    @Override
    public List<Map<String, Object>> getContractGoals() {
        List<Map<String, Object>> goals = wardenMapper.selectContractGoalList();
        for (Map<String, Object> goal : goals) {
            String goalId = (String) goal.get("goalId");
            goal.put("indicators", wardenMapper.selectIndicatorList(goalId));
        }
        return goals;
    }

    @Override
    public int saveContractGoal(String title) {
        return wardenMapper.insertContractGoal(title);
    }

    @Override
    public int deleteContractGoal(String goalId) {
        wardenMapper.deleteIndicatorByGoalId(goalId);
        return wardenMapper.deleteContractGoal(goalId);
    }

    // =========================================================
    // 경영계약 - 성과지표
    // =========================================================

    @Override
    public Map<String, Object> getIndicatorDetail(String goalId, String indId, String sub) {
        Map<String, Object> result = new HashMap<String, Object>();
        result.put("goal",    nvlMap(wardenMapper.selectContractGoal(goalId)));
        result.put("subTask", sub != null && !sub.isEmpty()
                              ? nvlMap(wardenMapper.selectSubTask(sub))
                              : new HashMap<String, Object>());

        Map<String, Object> indicator = wardenMapper.selectIndicator(indId);
        if (indicator == null) indicator = new HashMap<String, Object>();
        if (indId != null && !indId.isEmpty()) {
            Map<String, Object> detail = wardenMapper.selectIndicatorDetail(indId);
            if (detail != null) indicator.putAll(detail);
            List<Map<String, Object>> monthsDb = wardenMapper.selectIndicatorMonths(indId);
            indicator.put("months", buildMonthArray(monthsDb));
        }
        result.put("indicator", indicator);
        return result;
    }

    @Override
    public int saveContractIndicator(Map<String, Object> param) {
        return wardenMapper.insertContractIndicator(param);
    }

    @Override
    public int deleteContractIndicator(String goalId, String indId) {
        wardenMapper.deleteSubTaskByIndId(indId);
        wardenMapper.deleteIndicatorMonths(indId);
        wardenMapper.deleteIndicatorDetail(indId);
        return wardenMapper.deleteContractIndicator(indId);
    }

    @Override
    public int saveIndicatorDetail(Map<String, Object> param) {
        String indId = (String) param.get("indId");
        int exist = wardenMapper.selectIndicatorDetailCount(param);
        if (exist > 0) wardenMapper.updateIndicatorDetail(param);
        else           wardenMapper.insertIndicatorDetail(param);

        wardenMapper.deleteIndicatorMonths(indId);
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> months = (List<Map<String, Object>>) param.get("months");
        if (months != null) {
            for (int i = 0; i < months.size(); i++) {
                Map<String, Object> m = months.get(i);
                if (m != null) {
                    Map<String, Object> mp = new HashMap<String, Object>();
                    mp.put("indId",    indId);
                    mp.put("monthNum", i + 1);
                    mp.put("plan",     m.get("plan"));
                    mp.put("result",   m.get("result"));
                    wardenMapper.insertIndicatorMonth(mp);
                }
            }
        }
        return 1;
    }

    // =========================================================
    // 기타 주요 활동 / 기관장 활동내역
    // =========================================================

    @Override
    public List<Map<String, Object>> getActivities(String category) {
        if ("all".equals(category)) return wardenMapper.selectAllActivities();
        return wardenMapper.selectActivitiesByCategory(category);
    }

    @Override
    public Map<String, Object> getActivityDetail(String actId) {
        Map<String, Object> result = new HashMap<String, Object>();
        Map<String, Object> activity = wardenMapper.selectActivity(actId);
        if (activity != null) {
            List<Map<String, Object>> indicators = wardenMapper.selectActivityIndicators(actId);
            activity.put("indicators", indicators);
        }
        result.put("activity", nvlMap(activity));
        return result;
    }

    @Override
    public Map<String, Object> getIndicatorOptions() {
        Map<String, Object> result = new HashMap<String, Object>();
        result.put("leadership", wardenMapper.selectLeadershipOptions());
        result.put("contract",   wardenMapper.selectContractOptions());
        return result;
    }

    @Override
    public int saveActivity(Map<String, Object> param) {
        param.put("actId",  UUID.randomUUID().toString());
        param.put("status", Boolean.TRUE.equals(param.get("isDraft")) ? "draft" : "active");
        param.put("typeSecondary", joinList(param.get("typeSecondary")));
        wardenMapper.insertActivity(param);
        saveActivityIndicators(param);
        return 1;
    }

    @Override
    public int updateActivity(Map<String, Object> param) {
        param.put("status", Boolean.TRUE.equals(param.get("isDraft")) ? "draft" : "active");
        param.put("typeSecondary", joinList(param.get("typeSecondary")));
        wardenMapper.updateActivity(param);
        String actId = (String) param.get("actId");
        wardenMapper.deleteActivityIndicators(actId);
        saveActivityIndicators(param);
        return 1;
    }

    @Override
    public int deleteActivity(String actId) {
        wardenMapper.deleteActivityIndicators(actId);
        return wardenMapper.deleteActivity(actId);
    }

    // =========================================================
    // 내부 유틸
    // =========================================================

    private void saveActivityIndicators(Map<String, Object> param) {
        String actId = (String) param.get("actId");
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> indicators = (List<Map<String, Object>>) param.get("indicators");
        if (indicators == null) return;
        for (Map<String, Object> ind : indicators) {
            Map<String, Object> mp = new HashMap<String, Object>();
            mp.put("actId",    actId);
            mp.put("indId",    ind.get("id"));
            mp.put("indLabel", ind.get("label"));
            wardenMapper.insertActivityIndicator(mp);
        }
    }

    private List<Map<String, Object>> buildMonthArray(List<Map<String, Object>> dbRows) {
        List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
        for (int i = 0; i < 12; i++) result.add(new HashMap<String, Object>());
        if (dbRows == null) return result;
        for (Map<String, Object> row : dbRows) {
            Object numObj = row.get("monthNum");
            if (numObj == null) continue;
            int idx = ((Number) numObj).intValue() - 1;
            if (idx >= 0 && idx < 12) result.set(idx, row);
        }
        return result;
    }

    private Map<String, Object> nvlMap(Map<String, Object> m) {
        return m != null ? m : new HashMap<String, Object>();
    }

    private String joinList(Object val) {
        if (val == null) return "";
        if (val instanceof List) {
            @SuppressWarnings("unchecked")
            List<Object> list = (List<Object>) val;
            StringBuilder sb = new StringBuilder();
            for (Object item : list) {
                if (sb.length() > 0) sb.append(",");
                sb.append(item);
            }
            return sb.toString();
        }
        return val.toString();
    }
}
