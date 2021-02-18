var sub_id = 2;
var filters;
var fields;
var values1 = [0, 500];
var values2 = [0, 500];
var values3 = [0, 500];
var values4 = [0, 500];
$(document).ready(function () {
    $("#takeToCompare").hide();
    filters = JSON.parse($("#min_max__for_filter").text());
    fields = eval($("#filter_name").text());
    sub_cat = $("#sending_param").text() ?? sub_id;
    $.getJSON("/home/index?ajax=true&id=" + sub_cat, null, iterating);
    var loopVar = 0;
    for (var key in filters) {
        
        if (filters.hasOwnProperty(key)) {
            if (loopVar == 0) {
                values1[0] = filters[key];
            }
            else if (loopVar == 1) {
                values1[1] = filters[key];
            }
            else if (loopVar == 2) {
                values2[0] = filters[key];
            }
            else if (loopVar==3) {
                values2[1] = filters[key];
            }
            else if (loopVar ==4) {
                values3[0] = filters[key];
            }
            else if (loopVar ==5) {
                values3[1] = filters[key];
            }
            else if (loopVar ==6) {
                values4[0] = filters[key];
            }
            else if (loopVar ==7) {
                values4[1] = filters[key];
            }
            loopVar++;
        }
    }
    if (sub_cat == 4) {
        values1 = [0, 20];
        values2 = [8, 1024];
        values3 = [0, 32];
    }
    else if (sub_cat == 2) {
        values1 = [90, 250];
        values2 = [0, 30];
        values3 = [20, 256];
        values4 = [8, 70];
    }
    for (var field in fields) {
        let selectors = "#field" + field
        $(selectors).text(fields[field]);
        $(selectors).parent().parent().removeAttr("hidden");
        
    }
});
var divToAdd;
var jsonFile;


iterating = function iterating(datas) {
    jsonFile = datas;
    $("#SubCategory").text(datas[0].SubCategory);
    $("SubCategory").attr("href", window.location.href);
    $("#Category").text(datas[0].Category);
    for (let product in datas) {
        specs = datas[product].Specs;
        divToAdd = "" +
            "<div class='col-md-3 productBox'>\n" +
            "   <div id = '" + datas[product].id + "'>\n" +
            "       <a href='/details/index/?pid=" + datas[product].id + "'><img src='" + datas[product].Image + "' class='img-fluid' alt='Fan for product 1'></a>\n" +
            "       <div class='productItem'>\n" +
            "           <label class='ManfactureName'>" + datas[product].name + "</label>\n" +
            "           <label class='Series'>" + datas[product].Series + "</label>\n" +
            "           <label class='ModelNumber'>" + datas[product].Model + "</label>\n" +
            "       </div>\n" +
            "       <div>\n";
        if (datas[0].SubCategory == 'Fan') {
            divToAdd += "           <label class='airflow'>" + specs['Airflow'][1] + " CFM </label>\n" +
                "           <label class='secondMax' name='" + specs['Power(W)'][3] + "'>" + specs['Power(W)'][3] + " W at Max Speed</label>\n" +
                "           <label class='secondMin' name='" + specs['Power(W)'][1] + "' hidden>" + specs['Power(W)'][1] + " W at Min Speed</label>\n" +
                "           <label class='dbA'>" + specs['Sound at Max Speed'][1] + " dBA at Max Speed</label>\n" +
                "           <label class='fourthMax' name='" + specs['Height(in)'][3] + "'>" + specs['Height(in)'][3] + " '' fan sweep diameter</label>\n" +
                "           <label class='fourthMin' name='" + specs['Height(in)'][1] + "' hidden>" + specs['Height(in)'][1] + " '' fan sweep diameter</label>\n" +
                "           <label class='years' name='" + datas[product]['ModelYear'] + "' hidden>" + datas[product]['ModelYear'] + " Model</label>\n" +
                "           <label class='firstMax' name='" + specs['Operating Voltage(VAC)'][3] + "' hidden>" + specs['Power(W)'][3] + " W at Max Speed</label>\n" +
                "           <label class='firstMin' name='" + specs['Operating Voltage(VAC)'][1] + "' hidden>" + specs['Power(W)'][1] + " W at Min Speed</label>\n" +
                "           <label class='thirdMax' name='" + specs['Fan Speed(RPM)'][3] + "' hidden>" + specs['Power(W)'][3] + " W at Max Speed</label>\n" +
                "           <label class='thirdMin' name='" + specs['Fan Speed(RPM)'][1] + "' hidden>" + specs['Power(W)'][1] + " W at Min Speed</label>\n";
        }
        else if (datas[0].SubCategory == "Sofa") {
            divToAdd += "   <label class='years' name=" + datas[product]['ModelYear'] + ">" + datas[product]['ModelYear'] + " Model</label>\n" +
                "           <label class='manfacture'> Manfacture:  " + datas[product]['Manfacture'] + "</label>\n" +
                "           <label class='series'> Info:   " + datas[product]['Series_info'] + "</label>\n" +
                "           <label class='accessories'>Accessories:   " + datas[product]['Accessories'] + " </label>\n" +
                "           <label class='firstMin firstMax' name='" + specs['Length'][1] + "' hidden>" + specs['Length'][1] + " Foot</label>\n";
        }
        else if (datas[0].SubCategory == "Tablet") {
            divToAdd += "   <label class='years' name='" + datas[product]['ModelYear'] + "'>" + datas[product]['ModelYear'] + " Model</label>\n" +
                "           <label class='manfacture'> Manfacture:  " + datas[product]['Manfacture'] + "</label>\n" +
                "           <label class='series'> Info:   " + datas[product]['Series_info'] + "</label>\n" +
                "           <label class='accessories'>Accessories:   " + datas[product]['Accessories'] + " </label>\n" +
                "           <label class='thirdMin thirdMax' name='" + specs['RAM'][1] + "' hidden>Storage: " + specs['RAM'][1] + " GB</label>\n" +
                "           <label class='secondMin secondMax' name='" + specs['Storage'][1] + "' hidden>Storage: " + specs['Storage'][1] + " GB</label>\n" +
                "           <label class='firstMin firstMax' name='" + specs['Screen Size'][1] + "' hidden>Screen Size:" + specs['Screen Size'][1] + " Inch</label>\n";
        }

        divToAdd+=  "       </div>" +
                    "       <div class='row' style='margin-top:10px'>\n" +
            "           <div class='col-md-6 custom-control custom-checkbox'>\n" +
            "               <input type='checkbox' class='custom-control-inpuut' value='" + datas[product].id + "' onchange='changing_val(this)'>\n" +
                    "               <label for='defaultIndeterminate2'>Compare</label>\n" +
                    "           </div>\n" +
                    "           <div class='col-md-5 custombutton'>\n" +
                    "             <a href='/details/index/?pid=" + datas[product].id + "'>  <button type='button' class='btn btn-primary'>Get Details</button></a>\n" +
                    "           </div>\n" +
                    "       </div>\n" +
                    "   </div>\n" +
                    "</div> \n ";

        $("#loading").hide();
        $("#iterating").append(divToAdd);
        
    }

}

//first one
$(function () {
    $("#slider-range").slider({
        range: true,
        min: values1[0],
        max: values1[1],
        values: values1,
        slide: function (event, ui) {
            $("#amountMinAir").val("" + ui.values[0]);
            $("#amountMaxAir").val("" + ui.values[1]);
            if (sub_cat == 2) {
                Fansearch($("#amountMinAir").val(),
                    $("#amountMinPower").val(),
                    $("#amountMinSound").val(),
                    $("#amountMinDiameter").val(),
                    $("#amountMaxAir").val(),
                    $("#amountMaxPower").val(),
                    $("#amountMaxSound").val(),
                    $("#amountMaxDiameter").val(),
                    $(".firstMin"),
                    $(".secondMin"),
                    $(".thirdMin"),
                    $(".fourthMin"),
                    $(".firstMax"),
                    $(".secondMax"),
                    $(".thirdMax"),
                    $(".fourthMax")
                );
            }
            else if (sub_cat == 10) {
                Sofasearch($("#amountMinAir").val(),
                    $("#amountMaxAir").val(),
                    $(".firstMin"),
                    $(".firstMax")
                );
            }
            else if (sub_cat == 4) {
                TabletSearch($("#amountMinAir").val(),
                    $("#amountMinPower").val(),
                    $("#amountMinSound").val(),
                    $("#amountMaxAir").val(),
                    $("#amountMaxPower").val(),
                    $("#amountMaxSound").val(),
                    $(".firstMin"),
                    $(".secondMin"),
                    $(".thirdMin"),
                    $(".firstMax"),
                    $(".secondMax"),
                    $(".thirdMax"));
            }
        }
    });
    $("#amountMinAir").val("" + $("#slider-range").slider("values", 0));
    $("#amountMaxAir").val("" + $("#slider-range").slider("values", 1));
});


//secondone
$(function () {
    $("#slider-range-power").slider({
        range: true,
        min: values2[0],
        max: values2[1],
        values: values2,
        slide: function (event, ui) {
            $("#amountMinPower").val("" + ui.values[0]);
            $("#amountMaxPower").val("" + ui.values[1]);
            if (sub_cat == 2) {
                Fansearch($("#amountMinAir").val(),
                    $("#amountMinPower").val(),
                    $("#amountMinSound").val(),
                    $("#amountMinDiameter").val(),
                    $("#amountMaxAir").val(),
                    $("#amountMaxPower").val(),
                    $("#amountMaxSound").val(),
                    $("#amountMaxDiameter").val(),
                    $(".firstMin"),
                    $(".secondMin"),
                    $(".thirdMin"),
                    $(".fourthMin"),
                    $(".firstMax"),
                    $(".secondMax"),
                    $(".thirdMax"),
                    $(".fourthMax")
                );
            }
            else if (sub_cat == 10) {
                Sofasearch($("#amountMinAir").val(),
                    $("#amountMaxAir").val(),
                    $(".firstMin"),
                    $(".firstMax")
                );
            }
            else if (sub_cat == 4) {
                TabletSearch($("#amountMinAir").val(),
                    $("#amountMinPower").val(),
                    $("#amountMinSound").val(),
                    $("#amountMaxAir").val(),
                    $("#amountMaxPower").val(),
                    $("#amountMaxSound").val(),
                    $(".firstMin"),
                    $(".secondMin"),
                    $(".thirdMin"),
                    $(".firstMax"),
                    $(".secondMax"),
                    $(".thirdMax"));
            }
            
        }
    });
    $("#amountMinPower").val("" + $("#slider-range-power").slider("values", 0)),
    $("#amountMaxPower").val("" + $("#slider-range-power").slider("values", 1));
});



//Third
$(function () {
    $("#slider-range-sound").slider({
        range: true,
        min: values3[0],
        max: values3[1],
        values: values3,
        slide: function (event, ui) {
            $("#amountMinSound").val("" + ui.values[0]);
            $("#amountMaxSound").val("" + ui.values[1]);
            if (sub_cat == 2) {
                Fansearch($("#amountMinAir").val(),
                    $("#amountMinPower").val(),
                    $("#amountMinSound").val(),
                    $("#amountMinDiameter").val(),
                    $("#amountMaxAir").val(),
                    $("#amountMaxPower").val(),
                    $("#amountMaxSound").val(),
                    $("#amountMaxDiameter").val(),
                    $(".firstMin"),
                    $(".secondMin"),
                    $(".thirdMin"),
                    $(".fourthMin"),
                    $(".firstMax"),
                    $(".secondMax"),
                    $(".thirdMax"),
                    $(".fourthMax")
                );
            }
            else if (sub_cat == 10) {
                Sofasearch($("#amountMinAir").val(),
                    $("#amountMaxAir").val(),
                    $(".firstMin"),
                    $(".firstMax")
                );
            }
            else if (sub_cat == 4) {
                TabletSearch($("#amountMinAir").val(),
                    $("#amountMinPower").val(),
                    $("#amountMinSound").val(),
                    $("#amountMaxAir").val(),
                    $("#amountMaxPower").val(),
                    $("#amountMaxSound").val(),
                    $(".firstMin"),
                    $(".secondMin"),
                    $(".thirdMin"),
                    $(".firstMax"),
                    $(".secondMax"),
                    $(".thirdMax"));
            }
        }
    });
    $("#amountMinSound").val("" + $("#slider-range-sound").slider("values", 0)),
    $("#amountMaxSound").val("" + $("#slider-range-sound").slider("values", 1));
});

//Fourth
$(function () {
    $("#slider-range-diameter").slider({
        range: true,
        min: values4[0],
        max: values4[1],
        values: values4,
        slide: function (event, ui) {
            $("#amountMinDiameter").val("" + ui.values[0]);
            $("#amountMaxDiameter").val("" + ui.values[1]);
            if (sub_cat == 2) {
                Fansearch($("#amountMinAir").val(),
                    $("#amountMinPower").val(),
                    $("#amountMinSound").val(),
                    $("#amountMinDiameter").val(),
                    $("#amountMaxAir").val(),
                    $("#amountMaxPower").val(),
                    $("#amountMaxSound").val(),
                    $("#amountMaxDiameter").val(),
                    $(".firstMin"),
                    $(".secondMin"),
                    $(".thirdMin"),
                    $(".fourthMin"),
                    $(".firstMax"),
                    $(".secondMax"),
                    $(".thirdMax"),
                    $(".fourthMax")
                );
            }
            else if (sub_cat == 10) {
                Sofasearch($("#amountMinAir").val(),
                    $("#amountMaxAir").val(),
                    $(".firstMin"),
                    $(".firstMax")
                );
            }
            else if (sub_cat == 4) {
                TabletSearch($("#amountMinAir").val(),
                    $("#amountMinPower").val(),
                    $("#amountMinSound").val(),
                    $("#amountMaxAir").val(),
                    $("#amountMaxPower").val(),
                    $("#amountMaxSound").val(),
                    $(".firstMin"),
                    $(".secondMin"),
                    $(".thirdMin"),
                    $(".firstMax"),
                    $(".secondMax"),
                    $(".thirdMax"));
            }
        }
    });
    $("#amountMinDiameter").val("" + $("#slider-range-diameter").slider("values", 0)),
    $("#amountMaxDiameter").val("" + $("#slider-range-diameter").slider("values", 1));
});






var gef = [];
var gefAttr ="../../compare/index/"
var changing_val = function (id) {
    if (id.checked) {
        if (gef.length == 3) {
            id.checked = false;
            alert('Only three value allowed to compare')
        }
        else if (gef.length==0) {
            gef.push(id.value);
            gefAttr += "?list=" + id.value;
        }
        else {
            gef.push(id.value);
            gefAttr += "&list=" + id.value;
        }
        $("#takeToCompare").attr("href", gefAttr);
        $("#takeToCompare").show();
        
    }
    else {
        gef = gef.filter(item => item !== id.value);
        gefAttr = "../../compare/index/"
        if (gef.length == 0) {
            $("#takeToCompare").hide();
        }
        else {
            for (let i in gef) {
                if (i == 0) { gefAttr += "?list="+gef[i]; }
                else { gefAttr += "&list="+gef[i];}
            }
        }
        $("#takeToCompare").attr("href", gefAttr);
    }
}



function Fansearch(minVal1, minVal2, minVal3, minVal4,  maxVal1, maxVal2, maxVal3, maxVal4, minLabels1, minLabels2, minLabels3, minLabels4, maxLabels1, maxLabels2, maxLabels3, maxLabels4 ) {
    for (let i = 0; i < minLabels1.length; i++) {
        if ((parseInt(minLabels1[i].getAttribute("name")) <= parseInt(minVal1) || parseInt(maxLabels1[i].getAttribute("name")) >= parseInt(maxVal1)) ||
            (parseInt(minLabels2[i].getAttribute("name")) <= parseInt(minVal2) || parseInt(maxLabels2[i].getAttribute("name")) >= parseInt(maxVal2)) ||
            (parseInt(minLabels3[i].getAttribute("name")) <= parseInt(minVal3) || parseInt(maxLabels3[i].getAttribute("name")) >= parseInt(maxVal3)) ||
            (parseInt(minLabels4[i].getAttribute("name")) <= parseInt(minVal4) || parseInt(maxLabels4[i].getAttribute("name")) >= parseInt(maxVal4))) {

            minLabels1[i].parentElement.parentElement.parentElement.style.display = "none";

        }
        else {
            minLabels1[i].parentElement.parentElement.parentElement.style.display = "";
        }
    }
}

function Sofasearch(minVal1, maxVal1, minLabels1,  maxLabels1) {
    for (let i = 0; i < minLabels1.length; i++) {
        if ((parseInt(minLabels1[i].getAttribute("name")) <= parseInt(minVal1) || parseInt(maxLabels1[i].getAttribute("name")) >= parseInt(maxVal1))) {

            minLabels1[i].parentElement.parentElement.parentElement.style.display = "none";

        }
        else {
            minLabels1[i].parentElement.parentElement.parentElement.style.display = "";
        }
    }
}


function TabletSearch(minVal1, minVal2, minVal3,  maxVal1, maxVal2, maxVal3,  minLabels1, minLabels2, minLabels3,  maxLabels1, maxLabels2, maxLabels3) {
    for (let i = 0; i < minLabels1.length; i++) {
        if ((parseInt(minLabels1[i].getAttribute("name")) <= parseInt(minVal1) || parseInt(maxLabels1[i].getAttribute("name")) >= parseInt(maxVal1)) ||
            (parseInt(minLabels2[i].getAttribute("name")) <= parseInt(minVal2) || parseInt(maxLabels2[i].getAttribute("name")) >= parseInt(maxVal2)) ||
            (parseInt(minLabels3[i].getAttribute("name")) <= parseInt(minVal3) || parseInt(maxLabels3[i].getAttribute("name")) >= parseInt(maxVal3))) {

            minLabels1[i].parentElement.parentElement.parentElement.style.display = "none";

        }
        else {
            minLabels1[i].parentElement.parentElement.parentElement.style.display = "";
        }
    }
}
