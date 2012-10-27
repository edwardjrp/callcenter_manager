soundManager.onready ->
  window.chat_message = soundManager.createSound
    id: 'chat_message'
    url: '/assets/chat.mp3'
  window.system_alert = soundManager.createSound
    id: 'system_alert'
    url: '/assets/alert.mp3'