(function ($cms) {
    'use strict';

    $cms.templates.blockSideTagCloud = function blockSideTagCloud() {
        loadTagCloud(document.getElementById('tag_sphere'));
    };
}(window.$cms));

/* Derived from code at http://www.devirtuoso.com/2009/09/3d-sphere-using-jquery/ */

/*
 * DisplayObject3D ----------------------------------------------
 */
var DisplayObject3D = function () {
    return this;
};

DisplayObject3D.prototype._x = 0;
DisplayObject3D.prototype._y = 0;

//Create 3d Points
DisplayObject3D.prototype.make3DPoint = function (x, y, z) {
    var point = {};
    point.x = x;
    point.y = y;
    point.z = z;
    return point;
};

//Create 2d Points
DisplayObject3D.prototype.make2DPoint = function (x, y, depth, scaleFactor) {
    var point = {};
    point.x = x;
    point.y = y;
    point.depth = depth;
    point.scaleFactor = scaleFactor;
    return point;
};

DisplayObject3D.prototype.container = undefined;
DisplayObject3D.prototype.pointsArray = [];

DisplayObject3D.prototype.init = function (_container) {

    this.container = _container;
    this.containerId = this.container.id;
};

/*
 * DisplayObject3D End ----------------------------------------------
 */


/*
 * Camera3D ----------------------------------------------
 */
var Camera3D = function () {
};

Camera3D.prototype.x = 0;
Camera3D.prototype.y = 0;
Camera3D.prototype.z = 500;
Camera3D.prototype.focalLength = 1000;

Camera3D.prototype.scaleRatio = function (item) {
    return this.focalLength / (this.focalLength + item.z - this.z);
};

Camera3D.prototype.init = function (x, y, z, focalLength) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.focalLength = focalLength;
};


/*
 * Camera3D End ----------------------------------------------
 */


/*
 * Object3D ----------------------------------------------
 */
var Object3D = function (_container) {
    this.container = _container;
};

Object3D.prototype.objects = [];

Object3D.prototype.addChild = function (object3D) {

    this.objects.push(object3D);

    object3D.init(this.container);

    return object3D;
};

/*
 * Object3D End ----------------------------------------------
 */


/*
 * Scene3D ----------------------------------------------
 */

var Scene3D = function () {
};

Scene3D.prototype.sceneItems = [];
Scene3D.prototype.addToScene = function (object) {
    this.sceneItems.push(object);
};

Scene3D.prototype.Transform3DPointsTo2DPoints = function (points, axisRotations, camera) {
    var TransformedPointsArray = [];
    var sx = Math.sin(axisRotations.x);
    var cx = Math.cos(axisRotations.x);
    var sy = Math.sin(axisRotations.y);
    var cy = Math.cos(axisRotations.y);
    var sz = Math.sin(axisRotations.z);
    var cz = Math.cos(axisRotations.z);
    var x, y, z, xy, xz, yx, yz, zx, zy, scaleFactor;

    var i = points.length;

    while (i--) {
        x = points[i].x;
        y = points[i].y;
        z = points[i].z;

        // rotation around x
        xy = cx * y - sx * z;
        xz = sx * y + cx * z;
        // rotation around y
        yz = cy * xz - sy * x;
        yx = sy * xz + cy * x;
        // rotation around z
        zx = cz * yx - sz * xy;
        zy = sz * yx + cz * xy;

        scaleFactor = camera.focalLength / (camera.focalLength + yz);
        x = zx * scaleFactor + camera.x;
        y = zy * scaleFactor + camera.y;
        z = yz;

        var displayObject = new DisplayObject3D();
        TransformedPointsArray[i] = displayObject.make2DPoint(x, y, -z, scaleFactor);
    }

    return TransformedPointsArray;
};

Scene3D.prototype.renderCamera = function (camera) {

    for (var i = 0; i < this.sceneItems.length; i++) {

        var obj = this.sceneItems[i].objects[0];

        var screenPoints = this.Transform3DPointsTo2DPoints(obj.pointsArray, axisRotation, camera);

        var lis = document.getElementById(obj.containerId).getElementsByTagName("li");

        for (k = 0; k < obj.pointsArray.length; k++) {
            var currItem = null;

            currItem = lis[k];

            if (currItem) {
                currItem._x = screenPoints[k].x;
                currItem._y = screenPoints[k].y;
                currItem.scale = screenPoints[k].scaleFactor;

                currItem.style.position = "absolute";
                currItem.style.top = currItem._y + 'px';
                currItem.style.left = currItem._x + 'px';
                currItem.style.fontSize = 100 * currItem.scale + '%';

                $cms.dom.clearTransitionAndSetOpacity(currItem, (currItem.scale - 0.75) * 2);

            }


        }

    }
};

/*
 * Scene3D End ----------------------------------------------
 */


//Center for rotation
var axisRotation = new DisplayObject3D().make3DPoint(0, 0, 0);


var Sphere = function (radius, sides, numOfItems) {

    numOfItems++; // Makes maths work

    //Step through the number of rings.
    for (var j = sides; j >= 0; j--) {

        //Step through each point on a ring.
        for (var i = numOfItems / sides; i >= 0; i--) {
            //Space out each point evenly.
            var angle = i * Math.PI * 2 / (numOfItems / sides);
            var angleB = j * Math.PI * 2 / sides;

            //Figure out the x,y,z co-ordinates of each point.
            var x = Math.sin(angle) * Math.sin(angleB) * radius;
            var y = Math.cos(angle) * Math.sin(angleB) * radius;
            var z = Math.cos(angleB) * radius;

            //Put the point in an array.
            this.pointsArray.push(this.make3DPoint(x, y, z));
        }

    }
    ;

    var shuffle = function (o) { //v1.0
        for (var j, x, i = o.length; i; j = parseInt(Math.random() * i), x = o[--i], o[i] = o[j], o[j] = x);
        return o;
    };
    shuffle(this.pointsArray);
};

//Need to extend class to work in 3d engine.
Sphere.prototype = new DisplayObject3D();


function loadTagCloud(container) {
    var width = container.offsetWidth;
    var height = container.offsetHeight;

    // Make sure that the links are actually clickable
    var lis = container.getElementsByTagName("li");
    container.readyToClick = false;
    for (var i = 0; i < lis.length; i++) {
        lis[i].addEventListener('mouseover', function () {
            container.readyToClick = true;
        });
        lis[i].addEventListener('mouseout', function () {
            container.readyToClick = false;
        });
    }

    var sizing = (width > height && height != 0) ? height : width;

    var camera = new Camera3D();

    /*

     README! If you are using this on a different size to the default Composr block size, you will need to alter "25" and"10" below to offsets that
     are appropriate to your particular situation.

     */

    camera.init(width / 2 - 25 /* -ve offset because text positions are for top-left of first character */, height / 2 - 10, 0, 300);

    var item = new Object3D(container);

    var numItems = container.getElementsByTagName('li').length;
    item.addChild(new Sphere(sizing / 3.5 /* not /2 as we know the label lengths will protrude */, 10, numItems));

    var scene = new Scene3D();
    scene.addToScene(item);


    var mouseX, mouseY = 0;
    var speed = 1000;

    var animateIt = function () {
        var offsetX = $cms.dom.findPosX(container, true);
        var offsetY = $cms.dom.findPosY(container, true);
        var width = container.offsetWidth;
        var height = container.offsetHeight;

        var mouseX = window.mouse_x - offsetX - (width / 2);
        var mouseY = window.mouse_y - offsetY - (height / 2);

        if ((Math.abs(mouseX) * 2 < width) && (Math.abs(mouseY) * 2 < height) && (!container.readyToClick)) // Only re-render if mouse is there
        {
            axisRotation.y += mouseX / speed;
            axisRotation.x -= mouseY / speed;

            scene.renderCamera(camera);
        }

    };

    scene.renderCamera(camera); // First rendering
    window.setInterval(animateIt, 60);
}
