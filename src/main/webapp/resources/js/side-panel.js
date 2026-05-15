/**
 * Side panel interactions (year selection + section toggle).
 * Local-only UI state — no data persistence.
 */
(function () {
  function init() {
    /* 연도 선택: 클릭 시 active 전환 */
    var yearItems = document.querySelectorAll(".side-panel__year-item");
    for (var i = 0; i < yearItems.length; i++) {
      (function (btn) {
        btn.addEventListener("click", function () {
          var siblings = btn.parentNode.parentNode.querySelectorAll(
            ".side-panel__year-item"
          );
          for (var j = 0; j < siblings.length; j++) {
            siblings[j].classList.remove("is-active");
          }
          btn.classList.add("is-active");
        });
      })(yearItems[i]);
    }

    /* 섹션 헤더 클릭 시 접기/펼치기 */
    var headers = document.querySelectorAll(".side-panel__section-header");
    for (var k = 0; k < headers.length; k++) {
      (function (header) {
        header.addEventListener("click", function () {
          var section = header.parentNode;
          var expanded = section.getAttribute("aria-expanded") !== "false";
          section.setAttribute("aria-expanded", expanded ? "false" : "true");
          var list = section.querySelector(".side-panel__year-list");
          if (list) list.style.display = expanded ? "none" : "";
        });
      })(headers[k]);
    }
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }
})();
