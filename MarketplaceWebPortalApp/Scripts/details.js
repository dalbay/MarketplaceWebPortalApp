var LocalFile;
SaveToLocal = function SaveToLocal(datas) {
    LocalFile = datas;
    $("#Manfacture").text(datas.Manfacture);
    $("#Series").text(datas.Series);
    $("#Model").text(datas.Model);
    $("#UseType").text(datas.UseType);
    $("#Application").text(datas.Application);
    $("#MountingLocation").text(datas.MountingLocation);
    $("#Accessories").text(datas.Accessories);
    $("#ModelYear").text(datas.ModelYear);

    a = datas.Specs;

    for (key in a) {
        if (a.hasOwnProperty(key)) {
            var tbody = $("#ToAppend");
            var tr = "<tr>" +
                " <td colspan='2' class='desc'>" + key + "</td> ";
                
            if (a[key].length == 2) {
                tr += "<td colspan='4'>" + a[key][1] + "</td> " +
                    "</tr>";
            }
            else {
                tr += "<td class='desc'>" + a[key][0] + "</td> <td>" + a[key][1] + "</td> <td class='desc'>" + a[key][2] + "</td> <td>" + a[key][3] + "</td> </tr>";
            }
            tbody.append(tr);
            console.log(key + " = " + a[key]);
        }
    }
}
pid = $("#pid").text();
$.get("??ajax=true&pid="+pid, null, SaveToLocal);



