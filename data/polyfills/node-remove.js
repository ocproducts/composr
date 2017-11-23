(function () {
    'use strict';
    
    Element.prototype.remove = function remove() {
        if (this.parentNode !== null) {
            this.parentNode.removeChild(this);
        }
    };

    CharacterData.prototype.remove = function remove() {
        if (this.parentNode !== null) {
            this.parentNode.removeChild(this);
        }
    };

    DocumentType.prototype.remove = function remove() {
        if (this.parentNode !== null) {
            this.parentNode.removeChild(this);
        }
    };
}());
