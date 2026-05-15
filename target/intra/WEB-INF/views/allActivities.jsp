<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="pageTitle" value="기관장 활동내역"/>
<c:set var="activeMenu" value="activities"/>
<%@ include file="/WEB-INF/views/include/header.jsp"%>

        <div class="page page--activities">
          <section class="activities-panel aa-page" aria-labelledby="all-activities-heading">
            <h2 id="all-activities-heading" class="all-activities__title">기관장 활동내역</h2>
            <!-- KPI 요약 카드 -->
            <div class="aa-summary" aria-label="활동 요약 지표">
              <div class="aa-kpi"><span class="aa-kpi__label">총 활동</span><div class="aa-kpi__value-row"><strong class="aa-kpi__value" id="aa-kpi-total">0</strong><span class="aa-kpi__unit">건</span></div></div>
              <div class="aa-kpi"><span class="aa-kpi__label">이번 달</span><div class="aa-kpi__value-row"><strong class="aa-kpi__value" id="aa-kpi-month">0</strong><span class="aa-kpi__unit">건</span></div></div>
              <div class="aa-kpi"><span class="aa-kpi__label">증빙 보유율</span><div class="aa-kpi__value-row"><strong class="aa-kpi__value" id="aa-kpi-proof">0<small>%</small></strong></div></div>
              <div class="aa-kpi"><span class="aa-kpi__label">최근 활동</span><div class="aa-kpi__value-row"><strong class="aa-kpi__value aa-kpi__value--date" id="aa-kpi-last">-</strong></div></div>
            </div>
            <!-- 필터 -->
            <div class="activities-toolbar all-activities__toolbar aa-toolbar">
              <div class="all-activities__filter" role="tablist" aria-label="구분 필터">
                <button type="button" class="all-activities__filter-btn is-active" data-filter="all"        onclick="setCategory('all')">전체</button>
                <button type="button" class="all-activities__filter-btn"           data-filter="leadership" onclick="setCategory('leadership')">리더십</button>
                <button type="button" class="all-activities__filter-btn"           data-filter="contract"   onclick="setCategory('contract')">경영계약</button>
                <button type="button" class="all-activities__filter-btn"           data-filter="etc"        onclick="setCategory('etc')">기타 주요 활동</button>
              </div>
              <div class="aa-filters">
                <label class="aa-filter"><span class="aa-filter__label">활동유형</span>
                  <select id="aa-filter-type" class="aa-filter__select" onchange="currentFilter.type=this.value; currentPage=1; renderTable();">
                    <option value="">전체</option>
                    <option value="direction">방향제시</option>
                    <option value="resource">자원배분</option>
                    <option value="communication">소통협력</option>
                    <option value="execution">실행강화</option>
                    <option value="problem">문제해결</option>
                  </select>
                </label>
                <label class="aa-filter"><span class="aa-filter__label">기간</span>
                  <select id="aa-filter-period" class="aa-filter__select" onchange="currentFilter.period=this.value; currentPage=1; renderTable();">
                    <option value="all">전체</option>
                    <option value="1m">최근 1개월</option>
                    <option value="3m">최근 3개월</option>
                    <option value="6m">최근 6개월</option>
                    <option value="ytd">올해</option>
                  </select>
                </label>
                <label class="aa-filter aa-filter--search"><span class="aa-filter__label visually-hidden">검색</span>
                  <input type="search" id="aa-filter-search" class="aa-filter__input" placeholder="제목·내용·지표 검색"
                    oninput="currentFilter.keyword=this.value; currentPage=1; renderTable();">
                </label>
                <button type="button" class="aa-filter-reset" onclick="resetFilter()">초기화</button>
              </div>
            </div>
            <div class="all-activities__count-row">
              <span class="all-activities__count" id="all-activities-count" aria-live="polite"></span>
            </div>
            <!-- 테이블 -->
            <div class="activities-table-wrap">
              <table class="activities-table all-activities__table">
                <colgroup>
                  <col style="width:3.5rem"><col style="width:5.5rem"><col>
                  <col style="width:13rem"><col style="width:7.5rem"><col style="width:5rem">
                </colgroup>
                <thead>
                  <tr>
                    <th scope="col">No.</th>
                    <th scope="col">구분</th>
                    <th scope="col">활동내용</th>
                    <th scope="col">활동유형</th>
                    <th scope="col">활동일자</th>
                    <th scope="col">첨부</th>
                  </tr>
                </thead>
                <tbody id="all-activities-tbody">
                  <tr class="activities-table__empty-row"><td colspan="6">데이터를 불러오는 중입니다...</td></tr>
                </tbody>
              </table>
            </div>
            <nav class="result-pagination" id="all-activities-pagination" aria-label="활동내역 페이지"></nav>
          </section>
        </div>

  <script>
  var CTX = "${pageContext.request.contextPath}";
  var allData = [];
  var currentFilter = { category: "all", type: "", period: "all", keyword: "" };
  var PAGE_SIZE = 10, currentPage = 1;

  var KIND_LABEL = { leadership: "리더십", contract: "경영계약", etc: "기타 주요 활동" };
  var ACT_PRIMARY_LABELS = { direction:"방향제시", resource:"자원배분", communication:"소통협력", execution:"실행강화", problem:"문제해결" };

  function ajax(url, cb) {
    var xhr = new XMLHttpRequest();
    xhr.open("GET", url, true);
    xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
    xhr.onreadystatechange = function() {
      if (xhr.readyState === 4) {
        try { cb(JSON.parse(xhr.responseText), xhr.status); }
        catch(e) { cb(null, xhr.status); }
      }
    };
    xhr.send(null);
  }

  function setCategory(val) {
    currentFilter.category = val;
    currentPage = 1;
    var btns = document.querySelectorAll(".all-activities__filter-btn");
    for (var i = 0; i < btns.length; i++) {
      btns[i].className = "all-activities__filter-btn" + (btns[i].getAttribute("data-filter") === val ? " is-active" : "");
    }
    renderTable();
  }

  function resetFilter() {
    currentFilter = { category: "all", type: "", period: "all", keyword: "" };
    currentPage = 1;
    document.getElementById("aa-filter-type").value   = "";
    document.getElementById("aa-filter-period").value = "all";
    document.getElementById("aa-filter-search").value = "";
    setCategory("all");
  }

  function applyFilters() {
    var now = new Date();
    return allData.filter(function(a) {
      if (currentFilter.category !== "all" && a.category !== currentFilter.category) return false;
      if (currentFilter.type && a.typePrimary !== currentFilter.type) return false;
      if (currentFilter.keyword) {
        var kw = currentFilter.keyword.toLowerCase();
        if (((a.title || "") + " " + (a.content || "")).toLowerCase().indexOf(kw) < 0) return false;
      }
      if (currentFilter.period !== "all" && a.actDate) {
        var d = new Date(a.actDate), diff = (now - d) / 86400000;
        if (currentFilter.period === "1m" && diff > 30)  return false;
        if (currentFilter.period === "3m" && diff > 90)  return false;
        if (currentFilter.period === "6m" && diff > 180) return false;
        if (currentFilter.period === "ytd" && d.getFullYear() !== now.getFullYear()) return false;
      }
      return true;
    });
  }

  function goActivity(actId) {
    location.href = CTX + "/activities/edit.do?actId=" + encodeURIComponent(actId);
  }

  function renderTable() {
    var filtered = applyFilters();
    var tbody = document.getElementById("all-activities-tbody");
    document.getElementById("all-activities-count").textContent = "총 " + filtered.length + "건";

    var totalPages = Math.ceil(filtered.length / PAGE_SIZE) || 1;
    if (currentPage > totalPages) currentPage = 1;
    var start = (currentPage - 1) * PAGE_SIZE;
    var page  = filtered.slice(start, start + PAGE_SIZE);

    if (!page.length) {
      tbody.innerHTML = '<tr class="activities-table__empty-row"><td colspan="6">활동실적이 없습니다</td></tr>';
      document.getElementById("all-activities-pagination").innerHTML = "";
      return;
    }

    var html = "";
    for (var i = 0; i < page.length; i++) {
      var a = page[i];
      html += '<tr class="activities-table__row" style="cursor:pointer" onclick="goActivity(\'' + a.actId + '\')">'
        + '<td>' + (start + i + 1) + '</td>'
        + '<td><span class="dash-recent__tag dash-recent__tag--' + (a.category || "") + '">'
        + (KIND_LABEL[a.category] || a.category || "—") + '</span></td>'
        + '<td>' + (a.title || "—") + '</td>'
        + '<td>' + (ACT_PRIMARY_LABELS[a.typePrimary] || a.typePrimary || "—") + '</td>'
        + '<td>' + (a.actDate || "—") + '</td>'
        + '<td>' + ((a.proof && a.proof.trim()) ? "O" : "-") + '</td>'
        + '</tr>';
    }
    tbody.innerHTML = html;
    renderPagination(totalPages);
  }

  function renderPagination(totalPages) {
    var nav = document.getElementById("all-activities-pagination");
    if (totalPages < 2) { nav.innerHTML = ""; return; }
    var html = "";
    for (var p = 1; p <= totalPages; p++) {
      html += '<button type="button" class="result-pagination__btn' + (p === currentPage ? " is-active" : "")
        + '" onclick="goPage(' + p + ')">' + p + '</button>';
    }
    nav.innerHTML = html;
  }

  function goPage(p) { currentPage = p; renderTable(); }

  function updateKpis() {
    var now = new Date();
    var total = allData.length;
    var thisMonth = allData.filter(function(a) {
      if (!a.actDate) return false;
      var d = new Date(a.actDate);
      return d.getFullYear() === now.getFullYear() && d.getMonth() === now.getMonth();
    }).length;
    var proofCount = allData.filter(function(a) { return a.proof && a.proof.trim(); }).length;
    var proofRate  = total ? Math.round(proofCount / total * 100) : 0;
    var sorted     = allData.slice().sort(function(a, b) { return (b.actDate || "").localeCompare(a.actDate || ""); });
    document.getElementById("aa-kpi-total").textContent  = String(total);
    document.getElementById("aa-kpi-month").textContent  = String(thisMonth);
    document.getElementById("aa-kpi-proof").innerHTML    = String(proofRate) + '<small>%</small>';
    document.getElementById("aa-kpi-last").textContent   = sorted.length ? sorted[0].actDate : "-";
  }

  ajax(CTX + "/activities/all.ajax.do", function(data, status) {
    if (status === 200 && data && data.activities) {
      allData = data.activities;
      updateKpis();
      renderTable();
    }
  });
  </script>

<%@ include file="/WEB-INF/views/include/footer.jsp"%>
