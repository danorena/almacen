function validate(e){
    e.preventDefault();
    let formulario = document.getElementById('formQuery');
    console.log(document.getElementById("buscar").value);
    let buscar = document.getElementById("buscar");
    let categoria = document.getElementById("categoria");
    let send = document.getElementById('send').value;

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


    document.getElementById('category').value = categoria.options[categoria.selectedIndex].text;
    // console.log(document.getElementById('send').value);
    if (lVali == true) {
        document.getElementById('send').value = "true";
        formulario.submit();
    }
}
