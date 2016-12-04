/**
 * Created by Salman on 12/3/2016.
 */
/* <Prototyping for an ES5 compatible JS API for creating ES6 classes> */
function esClass(options) {
    var Constructor, ParentConstructor, staticProps, protoProps;

    options = objVal(options);
    staticProps = objVal(options.static);
    protoProps = objVal(options.prototype);
    Constructor = $cms.hasOwn(protoProps, 'constructor') ? protoProps.constructor : function Constructor() {};
    ParentConstructor = options.extends;

    if (typeof Constructor !== 'function') {
        throw new TypeError('$cms.esClass(): Invalid constructor function.');
    }

    if (typeof ParentConstructor === 'function') {
        Object.setPrototypeOf(Constructor, ParentConstructor);
        staticProps.base = base.bind(undefined, ParentConstructor);

        Constructor.prototype = Object.create(ParentConstructor.prototype);
    }

    $cms.define(Constructor, staticProps);
    $cms.define(Constructor.prototype, protoProps);

    return Constructor;
}

function ParentClass() {}

var MyClass = esClass({
    extends: ParentClass,

    static: {

    },

    prototype: {
        constructor: function MyClass() {
            MyClass.base(this, 'constructor', arguments);
        },

        someMethod: function someMethod() {

        },
        get width() {
            return this._width;
        },
        set width(value) {
            this._width = value;
        },
        myMethod: {
            configurable: false,
            value: function myMethod() {

            }
        }
    }
});
/* </JS API Prototyping> */