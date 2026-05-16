(function () {
  var ORDER  = ["direction","resource","communication","execution","problem"];
  var LABELS = { direction:"방향제시", resource:"자원배분", communication:"소통협력", execution:"실행강화", problem:"문제해결" };
  var COLORS = { direction:"#3b82f6", resource:"#f97316", communication:"#22c55e", execution:"#a855f7", problem:"#ef4444" };
  var NS = "http://www.w3.org/2000/svg";

  function donut(data) {
    var wrap = document.getElementById("aa-chart-type"); if (!wrap) return;
    wrap.innerHTML = "";
    var cnt = {}, tot = 0;
    ORDER.forEach(function(k){ cnt[k]=0; });
    data.forEach(function(a){ if(cnt[a.typePrimary]!=null) cnt[a.typePrimary]++; });
    ORDER.forEach(function(k){ tot+=cnt[k]; });

    var C=2*Math.PI*38, svg=document.createElementNS(NS,"svg");
    svg.setAttribute("class","aa-donut__svg"); svg.setAttribute("viewBox","0 0 100 100");
    var bg=document.createElementNS(NS,"circle");
    bg.setAttribute("class","aa-donut__track"); bg.setAttribute("cx","50"); bg.setAttribute("cy","50"); bg.setAttribute("r","38");
    svg.appendChild(bg);

    var off=0;
    if (tot>0) ORDER.forEach(function(k){
      if (!cnt[k]) return;
      var d=cnt[k]/tot*C, el=document.createElementNS(NS,"circle");
      el.setAttribute("class","aa-donut__seg"); el.setAttribute("cx","50"); el.setAttribute("cy","50"); el.setAttribute("r","38");
      el.setAttribute("stroke",COLORS[k]); el.setAttribute("stroke-dasharray",d+" "+(C-d)); el.setAttribute("stroke-dashoffset",-off);
      svg.appendChild(el); off+=d;
    });

    var cw=document.createElement("div"); cw.className="aa-donut__center";
    cw.innerHTML='<strong class="aa-donut__center-num">'+tot+'</strong><span class="aa-donut__center-lbl">총 건수</span>';
    var dn=document.createElement("div"); dn.className="aa-donut"; dn.appendChild(svg); dn.appendChild(cw);
    wrap.appendChild(dn);

    var ul=document.createElement("ul"); ul.className="aa-donut-legend";
    ORDER.forEach(function(k){
      ul.innerHTML+='<li class="aa-donut-legend__item">'
        +'<span class="aa-donut-legend__sw" style="background:'+COLORS[k]+'"></span>'
        +'<span class="aa-donut-legend__lb">'+LABELS[k]+'</span>'
        +'<span class="aa-donut-legend__cn">'+cnt[k]+'</span></li>';
    });
    wrap.appendChild(ul);
  }

  function bar(data) {
    var wrap = document.getElementById("aa-chart-month"); if (!wrap) return;
    wrap.innerHTML = "";
    var yr=new Date().getFullYear(), bm=[];
    for (var i=0;i<12;i++) bm.push({leadership:0,contract:0,etc:0,total:0});
    data.forEach(function(a){
      var d=new Date(a.actDate); if(isNaN(d)||d.getFullYear()!==yr) return;
      var b=bm[d.getMonth()]; if(b[a.category]!==undefined){b[a.category]++;b.total++;}
    });
    var mx=0; bm.forEach(function(b){ if(b.total>mx) mx=b.total; });
    bm.forEach(function(b,i){
      var col=document.createElement("div"); col.className="aa-stack__col";
      col.innerHTML='<span class="aa-stack__count">'+(b.total||"")+'</span>';
      var br=document.createElement("span"); br.className="aa-stack__bar";
      ["leadership","contract","etc"].forEach(function(k){
        if (!b[k]) return;
        var s=document.createElement("span"); s.className="aa-stack__seg aa-stack__seg--"+k;
        s.style.height=(mx?b[k]/mx*100:0)+"%"; br.appendChild(s);
      });
      col.appendChild(br);
      col.innerHTML+='<span class="aa-stack__month">'+(i+1)+"월</span>";
      wrap.appendChild(col);
    });
  }

  function init() {
    var x=new XMLHttpRequest();
    x.open("GET",(window.CTX||"")+"/activities/all.ajax.do",true);
    x.setRequestHeader("X-Requested-With","XMLHttpRequest");
    x.onreadystatechange=function(){
      if(x.readyState===4){ try{ var r=JSON.parse(x.responseText); if(r&&r.activities){donut(r.activities);bar(r.activities);} }catch(e){} }
    };
    x.send();
  }

  document.readyState==="loading"?document.addEventListener("DOMContentLoaded",init):init();
})();
