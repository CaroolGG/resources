const { ref } = Vue

// Customize language for dialog menus and carousels here

const load = Vue.createApp({
  setup () {
    return {
    //   CarouselText1: 'You can add/remove items, vehicles, jobs & gangs through the shared folder.',
    //   CarouselSubText1: 'Photo captured by: Markyoo#8068',
    //   CarouselText2: 'Adding additional player data can be achieved by modifying the qb-core player.lua file.',
    //   CarouselSubText2: 'Photo captured by: ihyajb#9723',
    //   CarouselText3: 'All server-specific adjustments can be made in the config.lua files throughout the build.',
    //   CarouselSubText3: 'Photo captured by: FLAPZ[INACTIV]#9925',
    //   CarouselText4: 'For additional support please join our community at discord.gg/qbcore',
    //   CarouselSubText4: 'Photo captured by: Robinerino#1312',

      DownloadTitle: 'Bienvenid@ a AMERICAN RP',
    //   DownloadDesc: "Hold tight while we begin downloading all the resources/assets required to play on QBCore Server. \n\nAfter download has been finished successfully, you'll be placed into the server and this screen will disappear. Please don't leave or turn off your PC. ",

      SettingsTitle: 'Ajustes',
      AudioTrackDesc1: 'Cuando está deshabilitado, la reproducción de la pista de audio actual se detendrá.',
      AutoPlayDesc2: 'Cuando las imágenes de carrusel estén deshabilitadas dejarán de circular y permanecerán en la última mostrada.',
      PlayVideoDesc3: 'Cuando está deshabilitado, el video dejará de reproducirse y permanecerá en pausa.',

      KeybindTitle: 'Guia de Teclas',
      Keybind1: 'Inventario',
      Keybind2: 'Rango de Voz',
      Keybind3: 'Teléfono',
      Keybind4: 'Cinturón',
      Keybind5: 'Menú Interacción',
      Keybind6: 'Menú Radial',
      Keybind7: 'Menú HUD',
      Keybind8: 'Radio',
      Keybind9: 'Estadísticas del PJ',
      Keybind10: 'Mando del Vehículo',
      Keybind11: 'Encender Motor',
      Keybind12: 'Señalar con el Dedo',
      Keybind13: 'Combinación de Teclas',
      Keybind14: 'Levantar Manos',
      Keybind15: 'Ranuras de Inventario',
      Keybind16: 'Control de Crucero',

      firstap: ref(true),
      secondap: ref(true),
      thirdap: ref(true),
      firstslide: ref(1),
      secondslide: ref('1'),
      thirdslide: ref('5'),
      audioplay: ref(true),
      playvideo: ref(true),
      download: ref(true),
      settings: ref(false),
    }
  }
})

load.use(Quasar, { config: {} })
load.mount('#loading-main')

var audio = document.getElementById("audio");
audio.volume = 0.05;

function audiotoggle() {
    var audio = document.getElementById("audio");
    if (audio.paused) {
        audio.play();
    } else {
        audio.pause();
    }
}

function videotoggle() {
    var video = document.getElementById("video");
    if (video.paused) {
        video.play();
    } else {
        video.pause();
    }
}

let count = 0;
let thisCount = 0;

const handlers = {
    startInitFunctionOrder(data) {
        count = data.count;
    },

    initFunctionInvoking(data) {
        document.querySelector(".thingy").style.left = "0%";
        document.querySelector(".thingy").style.width = (data.idx / count) * 100 + "%";
    },

    startDataFileEntries(data) {
        count = data.count;
    },

    performMapLoadFunction(data) {
        ++thisCount;

        document.querySelector(".thingy").style.left = "0%";
        document.querySelector(".thingy").style.width = (thisCount / count) * 100 + "%";
    },
};

window.addEventListener("message", function (e) {
    (handlers[e.data.eventName] || function () {})(e.data);
});
