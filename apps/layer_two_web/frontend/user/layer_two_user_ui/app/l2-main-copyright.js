export class l2_main_copyright extends HTMLElement {
    constructor() {
        super();
        this.attachShadow({ mode: 'open' });
    }

    connectedCallback() {
        this.shadowRoot.innerHTML = this.template();
    }

    l2_main_copyright_default_style(){
        return `
        :host {
           display: grid;
           justify-content: end;
           align-self: end;
           background: white;
           margin: 0px;
       }

       #copyright_text{
           font-size: calc(8px + 0.5vw);
           padding-right: 1vw;
       }`;
    }

    template() {
        return `
        <style>${this.l2_main_copyright_default_style()}</style>
        <div id="copyright_text">Copyright &copy; Dimitar Yosifov 2016-${new Date().getFullYear()} <a target= "_blank" href="https://github.com/LayerTwo/LayerTwo">Source Code</a></div>
        `;
    }

}
customElements.define('l2-main-copyright', l2_main_copyright)