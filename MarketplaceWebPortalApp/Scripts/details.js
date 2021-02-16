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

    a = datas.specs['TechSpec'];

    for (key in a) {
        if (a.hasOwnProperty(key)) {
            var tbody = $("#ToAppend");
            let tr = '<tr>\n' +
                ' < td colspan="2"> HEllo </td> ' +
                '< td colspan="4">Hi </td> ' +
                '</tr>';
            tbody.append(tr);
            console.log(key + " = " + a[key]);
        }
    }
}
pid = $("#pid").text();
$.get("?pid="+pid, null, SaveToLocal);



