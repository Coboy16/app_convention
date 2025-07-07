class LocalDashboardData {
  static Map<String, dynamic> get dashboardData => {
    "id": "event_2024_convention",
    "eventName": "Convención Tech 2024",
    "location": "Lima, Perú",
    "eventStatus": "live",
    "stats": {"posts": 156, "people": 89, "engagement": 95, "hours": 12},
    "todayHighlights": [
      {
        "id": "h1",
        "title": "Keynote de Apertura",
        "time": "9:00 AM",
        "description":
            "Presentación inaugural con las últimas tendencias en tecnología y desarrollo de software. Speakers internacionales compartirán insights sobre el futuro de la industria.",
        "location": "Auditorio Principal",
        "type": "keynote",
        "startTime": "2024-07-07T09:00:00Z",
        "endTime": "2024-07-07T10:00:00Z",
        "imageUrl": null,
        "isActive": true,
      },
      {
        "id": "h2",
        "title": "Workshop: Flutter Avanzado",
        "time": "11:00 AM",
        "description":
            "Aprende técnicas avanzadas de Flutter con expertos de Google. Incluye ejercicios prácticos y casos de uso reales.",
        "location": "Sala de Workshops A",
        "type": "workshop",
        "startTime": "2024-07-07T11:00:00Z",
        "endTime": "2024-07-07T12:30:00Z",
        "imageUrl": null,
        "isActive": true,
      },
      {
        "id": "h3",
        "title": "Almuerzo de Networking",
        "time": "12:30 PM",
        "description":
            "Momento para conectar con otros desarrolladores mientras disfrutas de un almuerzo delicioso. Networking informal y intercambio de experiencias.",
        "location": "Terraza del Convention Center",
        "type": "networking",
        "startTime": "2024-07-07T12:30:00Z",
        "endTime": "2024-07-07T13:30:00Z",
        "imageUrl": null,
        "isActive": true,
      },
      {
        "id": "h4",
        "title": "Panel: IA en el Desarrollo",
        "time": "2:00 PM",
        "description":
            "Mesa redonda sobre el impacto de la inteligencia artificial en el desarrollo de software. Debate con líderes de la industria.",
        "location": "Auditorio Principal",
        "type": "session",
        "startTime": "2024-07-07T14:00:00Z",
        "endTime": "2024-07-07T15:00:00Z",
        "imageUrl": null,
        "isActive": true,
      },
      {
        "id": "h5",
        "title": "Coffee Break & Demo",
        "time": "3:30 PM",
        "description":
            "Pausa para café y demostración de proyectos desarrollados por la comunidad. Networking informal.",
        "location": "Lobby Principal",
        "type": "break",
        "startTime": "2024-07-07T15:30:00Z",
        "endTime": "2024-07-07T16:00:00Z",
        "imageUrl": null,
        "isActive": true,
      },
    ],
    "recentUpdates": [
      {
        "id": "u1",
        "title": "¡Bienvenidos a la Convención Tech 2024!",
        "description":
            "Esperamos que tengan una experiencia increíble. No olviden seguir las redes sociales del evento para contenido exclusivo.",
        "type": "general",
        "timestamp": "2024-07-07T08:30:00Z",
        "imageUrl": null,
        "isImportant": false,
      },
      {
        "id": "u3",
        "title": "Cambio de Ubicación - Workshop Flutter",
        "description":
            "El Workshop de Flutter Avanzado se traslada al Salón B debido a la alta demanda. Capacidad ampliada para 150 personas.",
        "type": "venue",
        "timestamp": "2024-07-07T07:45:00Z",
        "imageUrl": null,
        "isImportant": true,
      },
      {
        "id": "u4",
        "title": "Nuevo Speaker Confirmado",
        "description":
            "Sarah Chen, Principal Engineer de Google Flutter Team, se unirá al panel de IA como speaker especial.",
        "type": "important",
        "timestamp": "2024-07-07T07:00:00Z",
        "imageUrl": null,
        "isImportant": false,
      },
      {
        "id": "u5",
        "title": "Menú de Almuerzo - Opciones Especiales",
        "description":
            "Se han añadido opciones veganas, vegetarianas y sin gluten al menú. Avisanos de alergias en el registro.",
        "type": "catering",
        "timestamp": "2024-07-07T06:30:00Z",
        "imageUrl": null,
        "isImportant": false,
      },
    ],
    "availableSurveys": [
      {
        "id": "s1",
        "title": "Evaluación del Evento",
        "description":
            "Tu opinión es muy valiosa para nosotros. Ayúdanos a mejorar futuros eventos compartiendo tu experiencia.",
        "questions": [
          {
            "id": "q1",
            "question": "¿Cómo calificarías el evento en general?",
            "type": "rating",
            "options": [],
            "isRequired": true,
          },
          {
            "id": "q2",
            "question": "¿Qué aspecto del evento te está gustando más?",
            "type": "singleChoice",
            "options": [
              "Calidad del contenido",
              "Oportunidades de networking",
              "Organización del evento",
            ],
            "isRequired": true,
          },
          {
            "id": "q3",
            "question":
                "¿Qué temas te gustaría ver en futuros eventos? (selecciona todos los que apliquen)",
            "type": "multipleChoice",
            "options": [
              "Inteligencia Artificial y ML",
              "Desarrollo Mobile (Flutter/React Native)",
              "Cloud Computing y DevOps",
            ],
            "isRequired": false,
          },
          {
            "id": "q4",
            "question":
                "¿Tienes algún comentario adicional o sugerencia para mejorar?",
            "type": "text",
            "options": [],
            "isRequired": false,
          },
        ],
        "expiresAt": "2024-07-14T23:59:59Z",
        "isCompleted": false,
        "responseCount": 23,
      },
      {
        "id": "s2",
        "title": "Feedback del Workshop Flutter",
        "description":
            "Comparte tu experiencia específica sobre el workshop de Flutter Avanzado.",
        "questions": [
          {
            "id": "w1",
            "question": "¿Qué tan útil fue el contenido del workshop?",
            "type": "rating",
            "options": [],
            "isRequired": true,
          },
          {
            "id": "w2",
            "question": "¿El nivel de dificultad fue apropiado para ti?",
            "type": "singleChoice",
            "options": [
              "Muy fácil - necesito más desafío",
              "Fácil - pero bien explicado",
              "Perfecto - nivel ideal",
              "Difícil - pero manejable",
              "Muy difícil - necesito más base",
            ],
            "isRequired": true,
          },
          {
            "id": "w3",
            "question": "¿Recomendarías este workshop a otros desarrolladores?",
            "type": "singleChoice",
            "options": [
              "Definitivamente sí",
              "Probablemente sí",
              "No estoy seguro",
              "Probablemente no",
              "Definitivamente no",
            ],
            "isRequired": true,
          },
        ],
        "expiresAt": "2024-07-14T23:59:59Z",
        "isCompleted": false,
        "responseCount": 8,
      },
    ],
    "lastUpdated": "2024-07-07T09:15:00Z",
  };
}
