let dashboardToggle = document.getElementsByClassName("dashboard-toggle")[0],
    hidableElements = document.getElementsByClassName("hidable-dashboard");

let showOrHideDashboard = () => {
  if(hidableElements[0].style.display === "none"){
    // forEach
    // bookListWrapper.style.display = "block";
    hidableElements.forEach((element) => {
      element.style.display === "block"
    })
  }
  else{
    // forEach
    // bookListWrapper.style.display = "block";
    hidableElements.forEach((element) => {
      element.style.display === "none"
    })
  }
}

dashboardToggle.addEventListener("click", showOrHideDashboard);
