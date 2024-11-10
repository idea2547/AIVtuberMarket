<script lang="ts">
    export const prerender = true;
    import { onMount } from "svelte";
    import '@pixi/unsafe-eval';

    import { Application, Ticker } from "pixi.js"
    import { appStore, speakStore } from "../stores/modelStore";

    console.log("Top level script loaded.");
    onMount(async () => {
        const { Live2DModel } = await import('pixi-live2d-display-lipsyncpatch');
        console.log("Hello from Renitube page");
        const app = new Application({
            view: document.getElementById('canvas') as HTMLCanvasElement,
            backgroundAlpha: 0,
            resizeTo: document.getElementById('canvas') as HTMLElement,
        });
        
        // "https://cdn.jsdelivr.net/gh/guansss/pixi-live2d-display/test/assets/haru/haru_greeter_t03.model3.json"
        // "/src/routes/renitube/resource/Hana/Nurse_chan_Draft.model3.json"
        // "/resource/hiyori_pro_en/runtime/hiyori_pro_t11.model3.json"
       const model = await Live2DModel.from("/resource/hiyori_pro_en/runtime/hiyori_pro_t11.model3.json", 
            {ticker: Ticker.shared}
        );

        app.stage.addChild(model);

          // transforms
        model.x = app.screen.width / 2;
        model.y = app.screen.height / 2 + 400;
        model.scale.set(0.3, 0.3);
        model.anchor.set(0.5, 0.5);

        const speak = (audioLink: string) => {
            model.speak(audioLink, {
                crossOrigin: "anonymous"
            });
        }

        console.log("Model and speak loaded.");
        speakStore.set(speak);
        appStore.set(app);

        // "https://cdn.jsdelivr.net/gh/RaSan147/pixi-live2d-display@v1.0.3/playground/test.mp3"
        // "/src/routes/renitube/resource/Hana/sounds/haru_normal_6.wav"
        model.on('hit', (hitAreas) => {
            console.log(hitAreas);
            if (hitAreas.includes('Body')) {
                model.speak("/src/routes/renitube/resource/Hana/sounds/haru_talk_13.wav", {
                    crossOrigin: "anonymous"
                });
            }
        });

        });
</script>

<canvas id="canvas" class="w-full h-full"></canvas>