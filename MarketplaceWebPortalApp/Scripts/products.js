var sub_id = 2;
var filters;
var fields;
$(document).ready(function () {
    $("#takeToCompare").hide();
    filters = JSON.parse($("#min_max__for_filter").text());
    fields = eval($("#filter_name").text());
    sub_cat = $("#sending_param").text() ?? sub_id;
    $.getJSON("/home/index?ajax=true&id=" + sub_cat, null, iterating);
    for (var key in filters) {
        if (filters.hasOwnProperty(key)) {
            console.log(filters[key]);
        }
    }
    for (var field in fields) {
        let selectors = "#field" + field
        $(selectors).text(fields[field]);
        
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
            "           <label id='Series'>" + datas[product].Series + "</label>\n" +
            "           <label id='ModelNumber'>" + datas[product].Model + "</label>\n" +
            "       </div>\n" +
            "       <div>\n";
        if (datas[0].SubCategory == 'Fan')
        {
            divToAdd += "           <label id='airflow'>" + specs['Airflow'][1] + " CFM </label>\n" +
                "           <label id='wMax'>" + specs['Power(W)'][3] + " W at Max Speed</label>\n" +
                "           <label id='dbA'>" + specs['Sound at Max Speed'][2] + " dBA at Max Speed</label>\n" +
                "           <label id='sweep'>" + specs['Height(in)'][3] + " '' fan sweep diameter</label>\n" 
        }
        else {
            divToAdd += "   <label id='airflow'>" + datas[product]['ModelYear'] + " Model</label>\n" +
                "           <label id='wMax'> Manfacture:  " + datas[product]['Manfacture'] + "</label>\n" +
                "           <label id='dbA'> Info:   " + datas[product]['Series_info'] + "</label>\n" +
                "           <label id='sweep'>Accessories:   " + datas[product]['Accessories'] + " </label>\n" 
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


$(function () {
    $("#slider-range-power").slider({
        range: true,
        min: 0,
        max: 500,
        values: [0, 500],
        slide: function (event, ui) {
            $("#amount").val("$" + ui.values[0] + " - $" + ui.values[1]);
        }
    });
    $("#amountMinPower").val("$" + $("#slider-range-power").slider("values", 0)),
        $("#amountMaxPower").val("$" + $("#slider-range-power").slider("values", 1));
});

$(function () {
    $("#slider-range-diameter").slider({
        range: true,
        min: 0,
        max: 500,
        values: [0, 500],
        slide: function (event, ui) {
            $("#amount").val("$" + ui.values[0] + " - $" + ui.values[1]);
        }
    });
    $("#amountMinDiameter").val("$" + $("#slider-range-diameter").slider("values", 0)),
        $("#amountMaxDiameter").val("$" + $("#slider-range-diameter").slider("values", 1));
});

$(function () {
    $("#slider-range-sound").slider({
        range: true,
        min: 0,
        max: 500,
        values: [0, 500],
        slide: function (event, ui) {
            $("#amount").val("$" + ui.values[0] + " - $" + ui.values[1]);
        }
    });
    $("#amountMinSound").val("$" + $("#slider-range-sound").slider("values", 0)),
        $("#amountMaxSound").val("$" + $("#slider-range-sound").slider("values", 1));
});

$(function () {
    $("#slider-range").slider({
        range: true,
        min: 0,
        max: 350,
        values: [60, 200],
        slide: function (event, ui) {
            $("#amount").val("$" + ui.values[0] + " - $" + ui.values[1]);
            $("#amountMinAir").val("$" + ui.values[0]);
            $("#amountMaxAir").val("$" + ui.values[1]);
        }
    });
    $("#amountMinAir").val("$" + $("#slider-ranger").slider("values", 0));
    $("#amountMaxAir").val("$" + $("#slider-range").slider("values", 1));
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



