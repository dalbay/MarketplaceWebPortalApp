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

var subCategories = ["Fans", "Vacuums", "Toasters"];
$("#search").autocomplete({
    source: subCategories
});

