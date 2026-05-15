package controller.warden;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import service.WardenService;

import java.util.HashMap;
import java.util.Map;

/**
 * WardenController
 * 기관장 실적·성과 관리시스템 통합 Controller
 *
 * ▶ 페이지 URL  : .do  → JSP 뷰 반환
 * ▶ AJAX URL   : .ajax.do → @ResponseBody JSON 반환
 */
@Controller
public class WardenController {

    @Autowired
    private WardenService wardenService;

    // =========================================================
    // 메인 / 관리자  (페이지)
    // =========================================================

    @RequestMapping("/main.do")
    public ModelAndView main() {
        return new ModelAndView("main");
    }

    @RequestMapping("/admin/main.do")
    public ModelAndView adminMain() {
        return new ModelAndView("admin");
    }

    // =========================================================
    // 리더십  (페이지)
    // =========================================================

    @RequestMapping("/leadership/list.do")
    public ModelAndView leadershipList() {
        return new ModelAndView("leadership");
    }

    @RequestMapping("/leadership/task.do")
    public ModelAndView leadershipTask(
            @RequestParam(value = "catId",  required = false) String catId,
            @RequestParam(value = "taskId", required = false) String taskId) {
        ModelAndView mav = new ModelAndView("leadershipTask");
        mav.addObject("catId",  catId);
        mav.addObject("taskId", taskId);
        return mav;
    }

    // =========================================================
    // 리더십  (AJAX)
    // =========================================================

    /** 범주 + 중점과제 목록 조회 */
    @RequestMapping("/leadership/list.ajax.do")
    @ResponseBody
    public Map<String, Object> leadershipListAjax() {
        Map<String, Object> result = new HashMap<String, Object>();
        result.put("categories", wardenService.getCategoryList());
        return result;
    }

    /** 중점과제 상세 조회 */
    @RequestMapping("/leadership/task/detail.ajax.do")
    @ResponseBody
    public Map<String, Object> leadershipTaskDetailAjax(
            @RequestParam(value = "catId",  required = false) String catId,
            @RequestParam(value = "taskId", required = false) String taskId) {
        return wardenService.getTaskDetail(catId, taskId);
    }

    /** 범주 저장 (POST) */
    @RequestMapping("/leadership/category/save.ajax.do")
    @ResponseBody
    public Map<String, Object> leadershipCategorySave(@RequestBody Map<String, Object> param) {
        Map<String, Object> result = new HashMap<String, Object>();
        int cnt = wardenService.saveCategory(
                (String) param.get("title"),
                (String) param.get("dept"));
        result.put("result", cnt > 0 ? "ok" : "fail");
        return result;
    }

    /** 범주 삭제 (POST) */
    @RequestMapping("/leadership/category/delete.ajax.do")
    @ResponseBody
    public Map<String, Object> leadershipCategoryDelete(@RequestBody Map<String, Object> param) {
        Map<String, Object> result = new HashMap<String, Object>();
        int cnt = wardenService.deleteCategory((String) param.get("catId"));
        result.put("result", cnt > 0 ? "ok" : "fail");
        return result;
    }

    /** 중점과제 저장 (POST) */
    @RequestMapping("/leadership/task/save.ajax.do")
    @ResponseBody
    public Map<String, Object> leadershipTaskSave(@RequestBody Map<String, Object> param) {
        Map<String, Object> result = new HashMap<String, Object>();
        int cnt = wardenService.saveTask(
                (String) param.get("catId"),
                (String) param.get("title"));
        result.put("result", cnt > 0 ? "ok" : "fail");
        return result;
    }

    /** 중점과제 삭제 (POST) */
    @RequestMapping("/leadership/task/delete.ajax.do")
    @ResponseBody
    public Map<String, Object> leadershipTaskDelete(@RequestBody Map<String, Object> param) {
        Map<String, Object> result = new HashMap<String, Object>();
        int cnt = wardenService.deleteTask(
                (String) param.get("catId"),
                (String) param.get("taskId"));
        result.put("result", cnt > 0 ? "ok" : "fail");
        return result;
    }

    /** 중점과제 상세 저장 (POST) — 월별 계획/실적 포함 */
    @RequestMapping("/leadership/task/detail/save.ajax.do")
    @ResponseBody
    public Map<String, Object> leadershipTaskDetailSave(@RequestBody Map<String, Object> param) {
        Map<String, Object> result = new HashMap<String, Object>();
        int cnt = wardenService.saveTaskDetail(param);
        result.put("result", cnt > 0 ? "ok" : "fail");
        return result;
    }

    // =========================================================
    // 경영계약  (페이지)
    // =========================================================

    @RequestMapping("/contract/list.do")
    public ModelAndView contractList() {
        return new ModelAndView("contract");
    }

    @RequestMapping("/contract/indicator.do")
    public ModelAndView contractIndicator(
            @RequestParam(value = "goalId", required = false) String goalId,
            @RequestParam(value = "indId",  required = false) String indId,
            @RequestParam(value = "sub",    required = false) String sub) {
        ModelAndView mav = new ModelAndView("contractIndicator");
        mav.addObject("goalId", goalId);
        mav.addObject("indId",  indId);
        mav.addObject("sub",    sub);
        return mav;
    }

    // =========================================================
    // 경영계약  (AJAX)
    // =========================================================

    /** 성과목표 + 성과지표 목록 조회 */
    @RequestMapping("/contract/list.ajax.do")
    @ResponseBody
    public Map<String, Object> contractListAjax() {
        Map<String, Object> result = new HashMap<String, Object>();
        result.put("goals", wardenService.getContractGoals());
        return result;
    }

    /** 성과지표 상세 조회 */
    @RequestMapping("/contract/indicator/detail.ajax.do")
    @ResponseBody
    public Map<String, Object> contractIndicatorDetailAjax(
            @RequestParam(value = "goalId", required = false) String goalId,
            @RequestParam(value = "indId",  required = false) String indId,
            @RequestParam(value = "sub",    required = false) String sub) {
        return wardenService.getIndicatorDetail(goalId, indId, sub);
    }

    /** 성과목표 저장 (POST) */
    @RequestMapping("/contract/goal/save.ajax.do")
    @ResponseBody
    public Map<String, Object> contractGoalSave(@RequestBody Map<String, Object> param) {
        Map<String, Object> result = new HashMap<String, Object>();
        int cnt = wardenService.saveContractGoal((String) param.get("title"));
        result.put("result", cnt > 0 ? "ok" : "fail");
        return result;
    }

    /** 성과목표 삭제 (POST) */
    @RequestMapping("/contract/goal/delete.ajax.do")
    @ResponseBody
    public Map<String, Object> contractGoalDelete(@RequestBody Map<String, Object> param) {
        Map<String, Object> result = new HashMap<String, Object>();
        int cnt = wardenService.deleteContractGoal((String) param.get("goalId"));
        result.put("result", cnt > 0 ? "ok" : "fail");
        return result;
    }

    /** 성과지표 저장 (POST) */
    @RequestMapping("/contract/indicator/save.ajax.do")
    @ResponseBody
    public Map<String, Object> contractIndicatorSave(@RequestBody Map<String, Object> param) {
        Map<String, Object> result = new HashMap<String, Object>();
        int cnt = wardenService.saveContractIndicator(param);
        result.put("result", cnt > 0 ? "ok" : "fail");
        return result;
    }

    /** 성과지표 삭제 (POST) */
    @RequestMapping("/contract/indicator/delete.ajax.do")
    @ResponseBody
    public Map<String, Object> contractIndicatorDelete(@RequestBody Map<String, Object> param) {
        Map<String, Object> result = new HashMap<String, Object>();
        int cnt = wardenService.deleteContractIndicator(
                (String) param.get("goalId"),
                (String) param.get("indId"));
        result.put("result", cnt > 0 ? "ok" : "fail");
        return result;
    }

    /** 성과지표 상세 저장 — 달성계획/월별 포함 (POST) */
    @RequestMapping("/contract/indicator/detail/save.ajax.do")
    @ResponseBody
    public Map<String, Object> contractIndicatorDetailSave(@RequestBody Map<String, Object> param) {
        Map<String, Object> result = new HashMap<String, Object>();
        int cnt = wardenService.saveIndicatorDetail(param);
        result.put("result", cnt > 0 ? "ok" : "fail");
        return result;
    }

    // =========================================================
    // 기타 주요 활동 / 기관장 활동내역  (페이지)
    // =========================================================

    @RequestMapping("/activities/list.do")
    public ModelAndView activitiesList() {
        ModelAndView mav = new ModelAndView("activities");
        mav.addObject("activities", wardenService.getActivities("etc"));
        return mav;
    }

    @RequestMapping("/activities/all.do")
    public ModelAndView activitiesAll() {
        return new ModelAndView("allActivities");
    }

    @RequestMapping("/activities/register.do")
    public ModelAndView activitiesRegister() {
        return new ModelAndView("activityRegister");
    }

    @RequestMapping("/activities/edit.do")
    public ModelAndView activitiesEdit(
            @RequestParam(value = "actId", required = false) String actId) {
        ModelAndView mav = new ModelAndView("activityRegister");
        mav.addObject("actId", actId);
        return mav;
    }

    // =========================================================
    // 기타 주요 활동  (AJAX)
    // =========================================================

    /** 기타 주요 활동 목록 (etc 구분만) */
    @RequestMapping("/activities/list.ajax.do")
    @ResponseBody
    public Map<String, Object> activitiesListAjax() {
        Map<String, Object> result = new HashMap<String, Object>();
        result.put("activities", wardenService.getActivities("etc"));
        return result;
    }

    /** 기관장 활동내역 전체 목록 (all) */
    @RequestMapping("/activities/all.ajax.do")
    @ResponseBody
    public Map<String, Object> activitiesAllAjax() {
        Map<String, Object> result = new HashMap<String, Object>();
        result.put("activities", wardenService.getActivities("all"));
        return result;
    }

    /** 활동 단건 상세 조회 */
    @RequestMapping("/activities/detail.ajax.do")
    @ResponseBody
    public Map<String, Object> activitiesDetailAjax(
            @RequestParam(value = "actId", required = false) String actId) {
        return wardenService.getActivityDetail(actId);
    }

    /** 연관 지표 드롭다운 옵션 목록 */
    @RequestMapping("/activities/indicator-options.ajax.do")
    @ResponseBody
    public Map<String, Object> activitiesIndicatorOptions() {
        return wardenService.getIndicatorOptions();
    }

    /** 활동 저장 (POST) */
    @RequestMapping("/activities/save.ajax.do")
    @ResponseBody
    public Map<String, Object> activitiesSave(@RequestBody Map<String, Object> param) {
        Map<String, Object> result = new HashMap<String, Object>();
        int cnt = wardenService.saveActivity(param);
        result.put("result", cnt > 0 ? "ok" : "fail");
        return result;
    }

    /** 활동 수정 (POST) */
    @RequestMapping("/activities/update.ajax.do")
    @ResponseBody
    public Map<String, Object> activitiesUpdate(@RequestBody Map<String, Object> param) {
        Map<String, Object> result = new HashMap<String, Object>();
        int cnt = wardenService.updateActivity(param);
        result.put("result", cnt > 0 ? "ok" : "fail");
        return result;
    }

    /** 활동 삭제 (POST) */
    @RequestMapping("/activities/delete.ajax.do")
    @ResponseBody
    public Map<String, Object> activitiesDelete(@RequestBody Map<String, Object> param) {
        Map<String, Object> result = new HashMap<String, Object>();
        int cnt = wardenService.deleteActivity((String) param.get("actId"));
        result.put("result", cnt > 0 ? "ok" : "fail");
        return result;
    }
}
