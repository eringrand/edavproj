d3.csv("data/SatandSurveydata.csv", function (survey_data) {

    var volumeChartSurveyA = dc.barChart("#dc-volume-chart-survey-a");
    var volumeChartSurveyB = dc.barChart("#dc-volume-chart-survey-b");
    var volumeChartSurveyC = dc.barChart("#dc-volume-chart-survey-c");
    var volumeChartSurveyD = dc.barChart("#dc-volume-chart-survey-d");
    var volumeChartSurveyE = dc.barChart("#dc-volume-chart-survey-e");
    var volumeChartSurveyF = dc.barChart("#dc-volume-chart-survey-f");

    var volumeChartSAT = dc.barChart("#dc-volume-chart-sat");

    var surveyData = crossfilter(survey_data),
        scoreA = surveyData.dimension(function(d) { return Math.round(d.s_q11e * 10) / 10}),
        scoresA = scoreA.group(function(d) { return Math.round(d * 5) / 5; }),
        scoreB = surveyData.dimension(function(d) { return Math.round(d.s_q2a * 10) / 10}),
        scoresB = scoreB.group(function(d) { return Math.round(d * 5) / 5; }),
        scoreC = surveyData.dimension(function(d) { return Math.round(d.s_q11a * 10) / 10}),
        scoresC = scoreC.group(function(d) { return Math.round(d * 5) / 5; }),
        scoreD = surveyData.dimension(function(d) { return Math.round(d.s_q1g * 10) / 10}),
        scoresD = scoreD.group(function(d) { return Math.round(d * 5) / 5; }),
        scoreE = surveyData.dimension(function(d) { return Math.round(d.s_q5a * 10) / 10}),
        scoresE = scoreE.group(function(d) { return Math.round(d * 5) / 5; }),
        scoreF = surveyData.dimension(function(d) { return Math.round(d.s_q4f * 10) / 10}),
        scoresF = scoreF.group(function(d) { return Math.round(d * 5) / 5; }),

        sat = surveyData.dimension(function(d) { return d.math; }),
        sats = sat.group(function(d) { return Math.round(d / 10) * 10; });


        volumeChartSurveyA.width(320)
            .height(150)
            .dimension(scoreA)
            .group(scoresA)
            .transitionDuration(1500)
            .centerBar(true)
            .gap(3)
            .x(d3.scale.linear().domain([4.5, 10.5]))
            .elasticY(true)
            .xAxis().tickFormat(function(v) {return v;});
            
        volumeChartSurveyA.xUnits(function(){return 25;});

        volumeChartSurveyB.width(320)
            .height(150)
            .dimension(scoreB)
            .group(scoresB)
            .transitionDuration(1500)
            .centerBar(true)
            .gap(3)
            .x(d3.scale.linear().domain([5.1, 10.5]))
            .elasticY(true)
            .xAxis().tickFormat(function(v) {return v;});

        volumeChartSurveyB.xUnits(function(){return 24;});

        volumeChartSurveyC.width(320)
            .height(150)
            .dimension(scoreC)
            .group(scoresC)
            .transitionDuration(1500)
            .centerBar(true)
            .gap(3)
            .x(d3.scale.linear().domain([4.5, 10.5]))
            .elasticY(true)
            .xAxis().tickFormat(function(v) {return v;});

        volumeChartSurveyC.xUnits(function(){return 25;});

        volumeChartSurveyD.width(320)
            .height(150)
            .dimension(scoreD)
            .group(scoresD)
            .transitionDuration(1500)
            .centerBar(true)
            .gap(3)
            .x(d3.scale.linear().domain([6.7, 10.5]))
            .elasticY(true)
            .xAxis().tickFormat(function(v) {return v;});

        volumeChartSurveyD.xUnits(function(){return 18;});

        volumeChartSurveyE.width(320)
            .height(150)
            .dimension(scoreE)
            .group(scoresE)
            .transitionDuration(1500)
            .centerBar(true)
            .gap(3)
            .x(d3.scale.linear().domain([5.7, 10.5]))
            .elasticY(true)
            .xAxis().tickFormat(function(v) {return v;});

        volumeChartSurveyE.xUnits(function(){return 21;});

        volumeChartSurveyF.width(320)
            .height(150)
            .dimension(scoreF)
            .group(scoresF)
            .transitionDuration(1500)
            .centerBar(true)
            .gap(3)
            .x(d3.scale.linear().domain([5.1, 10.5]))
            .elasticY(true)
            .xAxis().tickFormat(function(v) {return v;});

        volumeChartSurveyF.xUnits(function(){return 25;});

        volumeChartSAT.width(950)
                .height(230)
                .dimension(sat)
                .group(sats)
                .transitionDuration(1500)
                .centerBar(true)
                .gap(3)
                .x(d3.scale.linear().domain([300, 760]))
                .elasticY(true)
                .xAxis().tickFormat(function(v) {return v;});

        volumeChartSAT.xUnits(function(){return 40;});

    dc.renderAll();
});
