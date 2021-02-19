var pid = "";
iterating = function iterating(datas) {
    jsonFile = datas;
    for (products in datas) {
        thisProduct = datas[products]
        p = parseInt(products) + 1;
        $("#image" + p)[0].innerHTML = "<img style='  width: 300px; height: 300px; object - fit: contain;' src='" + thisProduct.Image + "'>";
        $("#manfacture" + p).text(thisProduct.Manfacture);
        $("#series" + p).text(thisProduct.Series);
        $("#model" + p).text(thisProduct.Model);
        $("#type" + p).text(thisProduct.UseType);
        $("#application" + p).text(thisProduct.Application);
        $("#mounting" + p).text(thisProduct.MountingLocation);
        $("#accesories" + p).text(thisProduct.Accessories);
        $("#year" + p).text(thisProduct.ModelYear);
    }
    
    if (datas.length == 1) {
        p1 = datas[0].Specs;
        for (key in p1) {
            if (p1.hasOwnProperty(key)) {
                var tbody = $("#toAppend");
                var tr = "<tr>" +
                    " <td colspan='4' class='desc'>" + key + "</td> ";

                if (p1[key].length == 2) {
                    tr += "<td colspan='4'>" + p1[key][1] + "</td> " +
                        "</tr>";
                }
                else {
                    tr += "<td class='desc'>" + p1[key][0] + "</td> <td>" + p1[key][1] + "</td> <td class='desc'>" + p1[key][2] + "</td> <td>" + p1[key][3] + "</td> </tr>";
                }
                tbody.append(tr);
                console.log(key + " = " + p1[key]);
            }
        }
    }


    else if (datas.length == 2)
    {
        var a = $(".product2");
        p1 = datas[0].Specs;
        p2 = datas[1].Specs;
        for (i = 0; i < a.length; i++)
        {
            $(".product2")[i].removeAttribute("hidden");
        }
        for (key in p1)
        {
            if (p1.hasOwnProperty(key))
            {
                var tbody = $("#toAppend");
                var tr = "<tr>" +
                    " <td colspan='4' class='desc'>" + key + "</td> ";

                if (p1[key].length == 2)
                {
                    tr += "<td colspan='4'>" + p1[key][1] + "</td> <td colspan='4'>" + p2[key][1] + "</td>" +"</tr>";
                }
                else
                {
                    tr += "<td class='desc'>" + p1[key][0] + "</td> <td>" + p1[key][1] + "</td> <td class='desc'>" + p1[key][2] + "</td> <td>" + p1[key][3] + "</td>" +
                        "<td class='desc'>" + p2[key][0] + "</td> <td>" + p2[key][1] + "</td> <td class='desc'>" + p2[key][2] + "</td> <td>" + p2[key][3] + "</td></tr > ";
                }
                tbody.append(tr);
                console.log(key + " = " + p1[key]);
            }
        }
        
    }
    else {
        p1 = datas[0].Specs;
        p2 = datas[1].Specs;
        p3 = datas[2].Specs;
        var a = $(".product3")
        for (i = 0; i < a.length; i++)
        {
            $(".product2")[i].removeAttribute("hidden");
            $(".product3")[i].removeAttribute("hidden");
        }
        for (key in p1) {
            if (p1.hasOwnProperty(key)) {
                var tbody = $("#toAppend");
                var tr = "<tr>" +
                    " <td colspan='4' class='desc'>" + key + "</td> ";

                if (p1[key].length == 2) {
                    tr += "<td colspan='4'>" + p1[key][1] + "</td> <td colspan='4'>" + p2[key][1]+ "</td> <td colspan = '4'> " + p3[key][1] + "</td>"+"</tr>";
                }
                else {
                    tr += "<td class='desc'>" + p1[key][0] + "</td> <td>" + p1[key][1] + "</td> <td class='desc'>" + p1[key][2] + "</td> <td>" + p1[key][3] + "</td>" +
                        "<td class='desc'>" + p2[key][0] + "</td> <td>" + p2[key][1] + "</td> <td class='desc'>" + p2[key][2] + "</td> <td>" + p2[key][3] + "</td>" +
                        "<td class='desc'>" + p3[key][0] + "</td> <td>" + p3[key][1] + "</td> <td class='desc'>" + p3[key][2] + "</td> <td>" + p3[key][3] + "</td>"+
                        "</tr>";
                }
                tbody.append(tr);
                console.log(key + " = " + a[key]);
            }
        }
        
    }


}

$(document).ready(function () {
    var ids = $('.ids');
    for (i = 0; i < ids.length; i++) {
        pid += "list=" + ids[i].innerText + "&";
    }
    pid += "ajax=true";
    console.log(pid);

    $.getJSON("?"+pid, null, iterating);
});


