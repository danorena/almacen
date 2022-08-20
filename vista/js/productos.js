function validate(e){
    e.preventDefault();
    let formulario = document.getElementById('formQuery');
    console.log(document.getElementById("buscar").value);
    let buscar = document.getElementById("buscar");
    let categoria = document.getElementById("categoria");

    lVali = true;
    if(buscar.value == ""){
        buscar.style.borderColor = "red";
        ohSnap('Ingrese el nombre o categoria...', { color: 'red' });
        lVali = false;
    }else{
        buscar.style.borderColor = ""; 
    }

    if(categoria.value == ""){
        categoria.style.borderColor = "red";
        ohSnap('Seleccione el tipo de busqueda ...', { color: 'red' });
        lVali = false;
    }
    else{
        categoria.style.borderColor = "";
    }



    if (lVali == true) {
        formulario.submit();
    }else{
        console.log(categoria.options[categoria.selectedIndex].text);
    }
}
