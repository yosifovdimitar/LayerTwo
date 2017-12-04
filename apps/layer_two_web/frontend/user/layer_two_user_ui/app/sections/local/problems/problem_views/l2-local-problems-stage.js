import { l2_local_list_problems } from "./list_problems/l2-local-list-problems.js"
import { l2_local_submit_problem } from "./submit_problem/l2-local-submit-problem.js"


export class l2_local_problems_stage extends HTMLElement {
    constructor() {
        super();
        this.attachShadow({ mode: 'open' });
        this.setAttribute("render-template", "false");
        this.setAttribute("show-template", "false");
    }

    static get observedAttributes() {
        return ['display-view'];
    }

    connectedCallback() {
        this.shadowRoot.innerHTML = this.template();
    }

    attributeChangedCallback(name, oldValue, newValue) {
        if (name === 'display-view' && newValue === 'list-problems') {
            this.shadowRoot.querySelector('l2-local-list-problems').setAttribute('render-template', 'true');
            this.shadowRoot.querySelector('l2-local-list-problems').setAttribute('show-template', 'true');
        } else {
            this.shadowRoot.querySelector('l2-local-list-problems').setAttribute('show-template', 'false');
        }

        if (name === 'display-view' && newValue === 'submit-problem') {
            this.shadowRoot.querySelector('l2-local-submit-problem').setAttribute('render-template', 'true');
            this.shadowRoot.querySelector('l2-local-submit-problem').setAttribute('show-template', 'true');
        } else {
            this.shadowRoot.querySelector('l2-local-submit-problem').setAttribute('show-template', 'false');
        }
    }

    l2_local_view_style_show(){
        return `
        :host {
            display: flex;
            flex-direction: column;
            flex-grow: 1;
            background: white;
        }`;
    }

    template() {
        return `
        <style>${this.l2_local_view_style_show()}</style>
        <l2-local-list-problems></l2-local-list-problems>
        <l2-local-submit-problem></l2-local-submit-problem>
        `;
    }

}

customElements.define("l2-local-problems-stage", l2_local_problems_stage)