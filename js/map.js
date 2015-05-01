/**
 * SAT NYC D3.js Map Project
 * Team: Maura Fitzgerald, Erin Grand, Casey Huang, Xu Huang, Stephen Ra
 */

/**
 * Our basic map's properties
 */
var width = 960,
    height = 900,
    centered;

/**
 * School district and school colors and legend colors
 */
var envLow = "#B0E2FF",
    envMed = "#5CACEE",
    envHigh = "#4A708B",
    envNa = "#c0c0c0";

var envLegendData = [
                     { "label": "High", "color": envHigh },
                     { "label": "Medium", "color": envMed },
                     { "label": "Low", "color": envLow },
                     { "label": "N/A", "color": envNa }
                    ];

var schLow = "#F0F8FF",
    schMed = "#1874CD",
    schHigh = "#000080",
    schNa = "#c0c0c0";

var schLegendData = [
                     { "label": "High", "color": schHigh },
                     { "label": "Medium", "color": schMed },
                     { "label": "Low", "color": schLow },
                     { "label": "N/A", "color": schNa }
                    ];

/**
 * Make map SVGs
 */
var projection = d3.geo.mercator()
    .center([-73.94, 40.73])
    .scale(140000)
    .translate([(width) / 2, (height)/2]);

var path = d3.geo.path()
    .projection(projection);

var div = d3.select("body").append("div")   
    .attr("class", "tooltip")               
    .style("opacity", 0);

var svg = d3.select("#map")
    .append("svg")
    .attr("width", width)
    .attr("height", height);

var smap = svg.append("g");

plotSchoolDistricts();

/**
 * School information text field functions
 */

var messageMap = {};
d3.csv('resource/messages.csv', function(rows) {
    rows.forEach(function(value, index) {
        var environment = value.Environment;
        if (!messageMap[value.School]) {
            messageMap[value.School] = {};
        }
        messageMap[value.School][environment] = value.Message;
    });
    displayInfo();
});

function displayInfo() {
    var school = schoolToKey().trim();
    var environment = envToKey().trim();

    if (messageMap[school] && messageMap[school][environment])
        $("#overlay").html(messageMap[school][environment]);
    else
        $("#overlay").html();
}

// Converting category names to csv key name
function schoolToKey() {
    var schoolName = $("#groupby").text().trim();
    if (schoolName == "Cluster")
        return "cluster";
    if (schoolName == "SAT Scores")
        return "sat";
    return "";
}

// Converting category names to csv key name
function envToKey() {
    var environmentName = $("#environment").text().trim();
    if (environmentName == "Graffiti")
        return "graffiti";
    if (environmentName == "Noise Complaints")
        return "noise";
    if (environmentName == "Public Assistance")
        return "assistance";
    if (environmentName == "School Attendance")
        return "attendence";
    if (environmentName == "School Enrollment")
        return "enrollment";
    return "";
}

/**
 * School and district dropdown coloring functions
 */

function color(property) {
  if (property == "LOW" || property == "D" || property == "F")
    { return schLow; }
  else if (property == "MED" || property == "B" || property == "C")
    { return schMed; }
  else if (property == "HIGH" || property == "A")
    { return schHigh; }
  else
    return schNa;
}

function colorDistrict(property) {
  if (property == "LOW") 
    { return envLow; }
  else if (property == "MEDIUM" || property == "MED") 
    { return envMed; }
  else if (property == "HIGH")
    { return envHigh; }
  else 
    return envNa;
}

// School factors
d3.select("#none").on("click", function() {
    d3.selectAll("circle")
        .style("fill", "blue");

    removeLegend("schLegend");
    $('#groupby').text('School');
    displayInfo();
});


d3.select("#sat").on("click", function() {
    colorSchools('SAT Scores', 'SAT');
});

function colorSchools(name, key) {
    removeLegend('schLegend');

    d3.selectAll("#school")
        .style("fill", function(d) {
        return color(d.properties[key]);
    });

    showLegend("schLegend", 20);
    $('#groupby').text(name);
    displayInfo();
}

// Environment factors
d3.select("#mapnone").on("click", function() {
    removeLegend("envLegend");

    d3.selectAll("path")
        .attr("fill", "#c0c0c0");

    $('#environment').text('Environment');
    displayInfo();
});

d3.select("#mapincome").on("click", function() {
    colorEnvironment('Income', 'income');
});

d3.select("#mapgraffiti").on("click", function() {
    colorEnvironment('Graffiti', 'graffiti');
});

d3.select("#mapnoise").on("click", function() {
    colorEnvironment('Noise Complaints', 'noise');
});

d3.select("#mapassistance").on("click", function() {
    colorEnvironment('Public Assistance', 'assistance');
});

d3.select("#mapattendance").on("click", function() {
    colorEnvironment('School Attendance', 'attendance');
});

d3.select("#mapenrollment").on("click", function() {
    colorEnvironment('School Enrollment', 'enrollment');
});

d3.select("#mapclasssize").on("click", function() }
    colorEnvironment('Average Class Size', enrollment');


function colorEnvironment(name, key) {
    d3.selectAll("path")
        .attr("fill", function(d) {
            return colorDistrict(d.properties[key]);
        });

    showLegend("envLegend", 130);
    $('#environment').text(name);
    displayInfo();
}

/**
 * Actually plotting school districts and schools
 */

function plotSchoolDistricts() {
    d3.json("json/districts_merged.json", function(error, nyb) {
        smap.attr("id", "schooldistrict")
            .selectAll(".state")
            .data(nyb.features)
            .enter().append("path")
            .attr("class", function(d){ return d.properties.SchoolDist; })
            .attr("d", path);

        plotSchools();
    });
}

function toTitleCase(str)
{
    return str.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();});
}

var circle_r = 5;
function plotSchools() {
    d3.json("json/schools_trim_merged.json", function(error, school) {
        var mouseDuration = 150;

        smap.selectAll(".school")
            .data(school.features)
            .enter().append("circle")
            .attr("id", "school")
            .attr("class", function(d) { return d.properties.SCHOOLNAME; })
            .attr("transform", function(d) { return "translate(" + projection(d.geometry.coordinates) + ")"; })
            .attr("r", circle_r)
            .attr("stroke-width", 0)
            .style("fill", "blue")
            .style("opacity", 0.60)
            .on("mouseover", function(d) {     
                d3.select(this).transition().duration(mouseDuration).style("opacity", 1);
                div.transition().duration(mouseDuration)
                .style("opacity", 1)
                .style("left", (d3.event.pageX + 10) + "px")
                .style("top", (d3.event.pageY -30) + "px")
                .style("fill", "#8DB6CD")
                .style("height", "90px");

                var toolText = toTitleCase(d.properties.SCHOOLNAME)
                if (d.properties.SAT_RAW != "<NA>" && d.properties.SAT_RAW != "null" && d.properties.SAT_RAW != "NaN") {
                    toolText += "<br /> The average SAT score is " + d.properties.SAT_RAW; 
                }
                if (d.properties.GRADE != "<NA>" && d.properties.GRADE != "null" && d.properties.GRADE != "NaN") {
                    toolText += "<br /> Progress Report Grade is " + d.properties.GRADE;
                }
                if (d.properties.GRAD_RAW != "<NA>" && d.properties.GRAD_RAW != "null" && d.properties.GRAD_RAW != "NaN") {
                    toolText += "<br /> The graduation rate is " + Math.round(d.properties.GRAD_RAW * 100) + "%";
                }


                div.html(toolText);
            })
            .on("mouseout", function() {
                d3.select(this)
                .transition().duration(mouseDuration)
                .style("opacity", 0.8);
                div.transition().duration(mouseDuration)
                .style("opacity", 0);
            });
    });
}

// Zoom
var zoom = d3.behavior.zoom()
    .on("zoom",function() {
        smap.attr("transform","translate("+ 
            d3.event.translate.join(",")+")scale("+d3.event.scale+")");
        smap.selectAll("circle")
            .attr("d", path.projection(projection))
            .attr("r", circle_r / d3.event.scale)
        smap.selectAll("path")  
            .attr("d", path.projection(projection)); 

  });

svg.call(zoom)

/**
 * District and school legend functions
 */

function showLegend(className, xOffset) {
    var yOffset = 175;
    // TODO: if-else's in here a little messy
    if (className == "envLegend") {
        var data = envLegendData;
        var title = "Environment";
        var textOffset = 66;
    }
    else {
        var data = schLegendData;
        var title = "School";
        var textOffset = 30;
    }

    d3.selectAll("g." + className).remove();

    var legend = svg.selectAll("g." + className)
        .data(data)
        .enter().append("g")
        .attr("class", className);

    legend.append("text")
        .attr("x", xOffset)
        .attr("y", yOffset)
        .attr("font-size", "16pt")
        .text(title);

    if (className == "envLegend") {
        legend.append("rect")
            .attr("x", xOffset)
            .attr("y", function(d, i) { return i * 18 + yOffset + 10; })
            .attr("width", 60)
            .attr("height", 18)
            .style("fill", function(d) { return d.color; });
    }
    else {
        legend.append("circle")
            .attr("cx", xOffset + 10)
            .attr("cy", function(d, i) { return i * 18 + yOffset + 18; })
            .attr("r", 5)
            .style("fill", function(d) { return d.color; });
    }

    legend.append("text")
        .attr("x", xOffset + textOffset)
        .attr("y", function(d, i) { return i * 18 + yOffset + 10; })
        .attr("dy", "14px")
        .text(function(d) { return d.label; });
}

function removeLegend(className) {
    d3.selectAll("g." + className).remove();
}
