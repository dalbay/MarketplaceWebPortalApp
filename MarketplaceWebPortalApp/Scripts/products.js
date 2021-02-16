var sub_id = 2;
$(document).ready(function () {
    $.getJSON("/home/index", null, iterating);

});
var divToAdd;
var jsonFile;


iterating = function iterating(datas) {
    jsonFile = datas;
    $("#SubCategory").text(datas[0].SubCategory);
    $("#Category").text(datas[0].Category);
    for (let product in datas) {
        specs = datas[product].Specs;
        divToAdd = "" +
            "<div class='col-md-3 productBox'>\n"+
            "   <div id = '" + datas[product].id+ "'>\n" +
            "       <a href='/details/index/?pid=" + datas[product].id+"'><img src='" + datas[product].Image+ "' class='img-fluid' alt='Fan for product 1'></a>\n" +
            "       <div class='productItem'>\n"+
            "           <label class='ManfactureName'>" + datas[product].name + "</label>\n" +
            "           <label id='Series'>"+datas[product].Series+"</label>\n" +
            "           <label id='ModelNumber'>"+datas[product].Model+"</label>\n" +
            "       </div>\n" +
            "       <div>\n"
        if (datas[0].SubCategory == 'Fan') {
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
                    "               <input type='checkbox' class='custom-control-input' class='defaultIndeterminate2'>\n" +
                    "               <label st class='custom-control-label' for='defaultIndeterminate2'>Compare</label>\n" +
                    "           </div>\n" +
                    "           <div class='col-md-5 custombutton'>\n" +
                    "               <button type='button' class='btn btn-primary'>Primary</button>\n" +
                    "           </div>\n" +
                    "       </div>\n" +
                    "   </div>\n" +
                    "</div>";


        $("#iterating").append(divToAdd);
        
    }

}
