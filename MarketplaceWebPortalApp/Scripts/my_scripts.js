var loadImage = function (event) {
    var outputImage = document.getElementById('imageOutput');
    outputImage.src = URL.createObjectURL(event.target.files[0]);
};

$(document).ready(function () {
    $("#confirmError").hide();
    $('#passwordReg, #confirmPasswordReg').on('keyup', function () {
        if ($('#passwordReg').val() == $('#confirmPasswordReg').val()) {
            $("#passwordReg").css('border-color', 'green');
            $("#confirmPasswordReg").css('border-color', 'green');
            $("#confirmError").hide();
        } else {
            $("#passwordReg").css('border-color', 'red');
            $("#confirmPasswordReg").css('border-color', 'red');
            $("#confirmError").show();
        }
    });
});
var searchCategory = [];
var subCategories = [];
function searchFilter(getInput) {
    var categoryName = $(getInput).attr('id');
    $.ajax({
        url: "GetSubCategory",
        data: { "categoryName": categoryName },
        type: "post",
        success: function (data) {
            for (var i = 0; i < data.length; i++) {
                subCategories.push(data[i].SubCategory_Name)
            }
            searchCategory.push(data);
            console.log(subCategories);
            console.log(searchCategory);
        }
    });
}

$("#search").autocomplete({
    source: subCategories
});

function redirectToSearch() {
    var search = $("#search").val();
    for (var i = 0; i <= searchCategory[0].length - 1; i++) {
        if (searchCategory[0][i].SubCategory_Name == search) {
            console.log("found");
            var id = searchCategory[0][i].SubCategory_ID;
            var url = "/Home/Index?id=" + id;
            window.location.href = url;
            subCategories = [];
            searchCategory = [];
            break;
        }
        
    }  
}

