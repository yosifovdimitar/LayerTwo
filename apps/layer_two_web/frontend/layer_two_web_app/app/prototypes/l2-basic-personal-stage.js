export class l2_basic_personal_stage extends HTMLElement {
    constructor() {
        super();
        this.attachShadow({ mode: 'open' });
    }

    connectedCallback() {
        this.shadowRoot.innerHTML = this.template();
    }

    l2_basic_personal_stage_style_show(){
        return `
        :host {
            display: flex;
            height: 100%;
            width: 100%;
            background: white;
        }
        
        svg {
            height: 100%;
            width: 100%;
        }`;
    }

    template() {
        return `
        <style>${this.l2_basic_personal_stage_style_show()}</style>
        <svg id="personal_stage_svg" version="1.1" viewBox="0 0 1120.3399 547.64336" xmlns="http://www.w3.org/2000/svg">
        <ellipse cx="560.16998" cy="285.47336" rx="275.82001" ry="93.360001" style="fill:none;opacity:.98000004;stroke-dasharray:3, 3;stroke-width:3;stroke:#969696"/>
        <ellipse cx="560.16998" cy="308.51337" rx="398.64001" ry="150.24001" style="fill:none;opacity:.98000004;stroke-dasharray:3, 3;stroke-width:3;stroke:#969696"/>
        <ellipse cx="560.16998" cy="341.05334" rx="558.66998" ry="205.09" style="fill:none;opacity:.98000004;stroke-dasharray:3, 3;stroke-width:3;stroke:#989898"/>
        <path d="m513.39198 292.42337c-.446-31.298-3.682-57.092-22.776-78.588-8.7126-14.467-13.093-28.521-14.094-40.961 23.029-14.466 42.462-25.09 63.612-33.485v-18.305c-7.614-10.639-11.889-16.771-17.688-25.340002-3.1862-15.155-5.6528-31.683-7.8478-45.679s1.41-25.452 13.644-36.857c12.234-11.406 31.9278-11.644004 31.9278-11.644004s19.6938.2379965 31.9278 11.643997c12.234 11.405 15.839 22.861 13.644 36.857s-4.6616 30.524-7.8478 45.679c-5.799 8.569009-10.074 14.701009-17.688 25.340009v18.305c21.15 8.395 40.583 19.019 63.612 33.485-1.001 12.44-5.3814 26.494-14.094 40.961-19.094 21.496-22.33 47.29-22.776 78.588-9.292 11.807-25.178 18.659-46.778 18.033-21.6.626-37.486-6.226-46.778-18.033z" style="fill:#fff;stroke-width:3.1285;stroke:#000"/>
        </svg>`;
    }

}
customElements.define('l2-basic-personal-stage', l2_basic_personal_stage)