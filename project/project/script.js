// script.js

// Function to display tutors on the page based on the course
function displayTutors(course) {
    const tutorList = document.getElementById('tutor-list');
    tutorList.innerHTML = '';

    fetch('get-tutors.jsp?course=' + course)
        .then(response => response.json())
        .then(tutors => {
            tutors.forEach(tutor => {
                const tutorDiv = document.createElement('div');
                tutorDiv.className = 'tutor';

                const tutorImg = document.createElement('img');
                tutorImg.src = tutor.profilePic;
                tutorImg.alt = tutor.name;

                const tutorName = document.createElement('h2');
                tutorName.textContent = tutor.name;

                const tutorDescription = document.createElement('p');
                tutorDescription.textContent = tutor.description;

                tutorDiv.appendChild(tutorImg);
                tutorDiv.appendChild(tutorName);
                tutorDiv.appendChild(tutorDescription);

                tutorList.appendChild(tutorDiv);
            });
        })
        .catch(error => console.error('Error fetching tutors:', error));
}

// Check which page is being loaded and call displayTutors with appropriate course
document.addEventListener('DOMContentLoaded', () => {
    const page = document.body.getAttribute('data-page');
    if (page) {
        displayTutors(page);
    }
});

// Smooth scrolling for navigation links
document.querySelectorAll('nav a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function(e) {
        e.preventDefault();

        document.querySelector(this.getAttribute('href')).scrollIntoView({
            behavior: 'smooth'
        });
    });
});
