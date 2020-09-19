
import strformat
from sequtils import repeat
from strutils import toLower

const NL = "\p"
const SQ = "'"[0]

#[
let msg = "Bonjour"
echo SQ & msg & SQ
echo fmt"xxx{SQ & msg & SQ : 18}xxx"
]#

#[
from math import pi, sin, cos
PI = pi
DEG2RAD = PI/180.0
RAD2DEG = 180.0/PI
]#

import Tables

import os

const contentPath = "OpenGLModerne/opengl_tutorials_python-master/Content"
const Obj3D       = "Obj3D"

const debugTexturePathFile* = Obj3D & "triangleAndSquare.jpg"

type
    Model* = ref object of RootObj
        name*: string
        objPath*, objFile*, objPathFile*, texFile*, texPathFile* : string
        swapYZ*, normalize*, fast*: bool
        bgRGB*: array[3, float]
        info* : string
        ignoreObjs*: seq[string]

proc addIndexToFileName(fName: string; index:int): string =
    echo fmt"addIndexToFileName({result}, index:{index}"
    assert index > 0
    var (dir, name, ext) = splitFile(fName)
    #echo fmt"dir:{dir}, name:{name}, ext:{ext}"
    name &= $index
    #echo fmt"dir:{dir}, name:{name}, ext:{ext}"
    result = joinPath([dir, name]) & ext
    echo fmt"addIndexToFileName ->: {result}"

proc newModel(name:string; objPathFile:seq[string]; texPathFile:seq[string]= @[]; fileIndex=0; bgRGB: array[3, float]=[0.4, 0.4, 0.9]; normalize=false; swapYZ=false, info="", ignoreObjs: seq[string]= @[]): Model =
    result = new Model
    result.name = name
    var
        objPathFil = objPathFile
        texPathFil = texPathFile

    if fileIndex > 0:
        objPathFil[^1] = addIndexToFileName(objPathFil[^1], fileIndex)
        if texPathFil.len > 0:
            texPathFil[^1] = addIndexToFileName(texPathFil[^1], fileIndex)

    result.objPath     = joinPath(objPathFil[0 ..< ^1])
    result.objFile     = objPathFil[^1]
    result.objPathFile = joinPath(objPathFil)
    #echo fmt"result.objPathFile: {result.objPathFile}"

    result.texFile     = if texPathFil.len == 0: "" else: texPathFil[^1]
    result.texPathFile = if texPathFil.len == 0: "" else: joinPath(texPathFil)

    result.swapYZ     = swapYZ
    result.bgRGB      = bgRGB
    result.info       = info
    result.ignoreObjs = ignoreObjs
    result.normalize  = normalize
    result.fast       = true

proc `$`*(self: Model): string =
    result  = fmt"Model {SQ & self.name & SQ:20}:"
    result &= fmt"{NL}objPath:'{self.objPath:24}', objFile:'{self.objFile:24}', objPathFile:'{self.objPathFile}'"
    if self.texFile.len > 0:result &= fmt"{NL}{self.texFile:24} in {self.texPathFile}"
    #result &= "{NL}Initial rotation X,Y,Z:%6.3f,%6.3f,%6.3f"%(self.radX*RAD2DEG, self.radY*RAD2DEG, self.radZ*RAD2DEG)
    #result &= "{NL}Initial rotSpeed X,Y,Z:%6.3f,%6.3f,%6.3f"%(self.dRadX*RAD2DEG, self.dRadY*RAD2DEG, self.dRadZ*RAD2DEG)
    #result &= "{NL}normalize:%s, fast:%s"%(self.normalize, self.fast)
    result &= fmt"{NL}swapYZ:{self.swapYZ}, bgRGB:{self.bgRGB}"
    if self.info != "" : result &= NL & self.info
    result &= NL

#----------------------- fill datas ------------------------------

type Models* = OrderedTable[string, Model]

var models*: Models
models = initOrderedTable[string, Model]() # () is important = dict()

proc getModel*(modelName:string): Model =
    let nameLower = modelName.toLower
    if nameLower.in(models):
        result = models[nameLower]

var mdl: Model

mdl = newModel(name      = "Suzanne",
            objPathFile  = @[contentPath, "suzanne.obj"],
            texPathFile  = @[contentPath, "uvmap_suzanne.bmp"],
            info         = "968 faces, 2_904 vertexs")
models[mdl.name.toLower] = mdl

mdl = newModel(name     = "Eva",
            objPathFile = @[contentPath, "eva.obj"],
            #texPathFile= @[contentPath, "uvmap_suzanne.bmp"],
            info        = "  968 faces, 2_904 vertexs")
models[mdl.name.toLower] = mdl

mdl = newModel(name        = "Kangourou",
            objPathFile = @[Obj3D, "Kangourou", "12271_Kangaroo_v1_L3.obj"],
            swapYZ      = true,
            bgRGB       =  [0.3, 0.5, 0.1], # green back ground
            normalize   = true,
            info        = " 32_032 faces, 192_192 vertexs"
      )
models[mdl.name.toLower] = mdl

mdl = newModel(name     = "Cygne",
            objPathFile = @[Obj3D, "Cygne", "Mute_Swan.obj"],
            swapYZ      = true,
            bgRGB       = [0.3, 0.5, 0.1], # green back ground
            normalize   = true,
            info        = " 32_032 faces,  192_192 vertexs"
      )
models[mdl.name.toLower] = mdl

mdl = newModel(name     = "Cylindre3",
            objPathFile = @[Obj3D, "TestObjs", "cylindre3.obj"],
      )
models[mdl.name.toLower] = mdl

mdl = newModel(name     = "Cylindre4",
            objPathFile = @[Obj3D, "TestObjs", "cylindre4.obj"],
      )
models[mdl.name.toLower] = mdl

mdl = newModel(name     = "Cylindre6",
            objPathFile = @[Obj3D, "TestObjs", "cylindre6.obj"],
      )
models[mdl.name.toLower] = mdl

mdl = newModel(name     = "Cylindre8",
            objPathFile = @[Obj3D, "TestObjs", "cylindre8.obj"],
      )
models[mdl.name.toLower] = mdl

mdl = newModel(name     = "Cylindre8old",
            objPathFile = @[contentPath, "cylindre8.obj"],
            texPathFile = @[contentPath, "textureCylindre8.png"],
            #fileIndex   = 4,
            info        = "    968 faces,   2_904 vertexs"
      )
models[mdl.name.toLower] = mdl

mdl = newModel(name     = "NudeFemale",
            objPathFile = @[Obj3D, "Humans", "Whipper", "Nude.obj"],
            normalize   = true,
            info        = "  5_184 faces,   15_552 vertexs"
      )
models[mdl.name.toLower] = mdl

mdl = newModel(name     = "House",
            objPathFile = @[Obj3D, "Buildings", "ordinary-house", "house.obj"],
            normalize   = true,
            info        = "  xxxx faces,   xxx vertexs"
      )
models[mdl.name.toLower] = mdl

mdl = newModel(name     = "Castle",
            objPathFile = @[Obj3D, "Buildings", "castle-low-poly", "Dartmouth_Church_Devon.obj"],
            normalize   = true,
            info        = "  xxxx faces,   xxx vertexs"
      )
models[mdl.name.toLower] = mdl

mdl = newModel(name     = "NudeMale",
            objPathFile = @[Obj3D, "Humans", "NudeMaleNoTexture", "FinalBaseMesh.obj"],
            normalize   = true,
            info        = "    968 faces,     2_904 vertexs"
      )
models[mdl.name.toLower] = mdl

mdl = newModel(name     = "MaleHead",
            objPathFile = @[Obj3D, "Humans", "realistic-lowpoly-head", "head.obj"],
            normalize   = true,
            info        = "    xxx faces,     xxx vertexs"
      )
models[mdl.name.toLower] = mdl

mdl = newModel(name     = "Ballerina",
            objPathFile = @[Obj3D, "Humans", "ballerina.obj"],
            info        = "  160_194 faces,    480_600 vertexs"
      )
models[mdl.name.toLower] = mdl

mdl = newModel(name     = "Discobol",
            objPathFile = @[Obj3D, "Humans", "The_Discobolus.obj"],
            info        = "  201_698 faces,    605_094 vertexs"
      )
models[mdl.name.toLower] = mdl

mdl = newModel(name     = "Mercury",
            objPathFile = @[Obj3D, "cadnav.com_model", "Models_E0503A007", "mercury.obj"],
            info        = "1_469_928 faces,  4_409_784 vertexs"
      )
models[mdl.name.toLower] = mdl

mdl = newModel(name     = "Earth1",
            objPathFile = @[Obj3D, "Earth1", "earth.obj"],
            bgRGB       = [0.1, 0.1, 0.4],  # dark blue
            info        = "  x faces,    x vertexs"
      )
models[mdl.name.toLower] = mdl

mdl = newModel(name     = "Toto",
            objPathFile = @["", "toto.obj"],
            info = ""
      )
models[mdl.name.toLower] = mdl

#[
    info = """
  249_075 faces   in   8.212 s fast
1_494_450 vertexs in   1.889 s Problem ! ???"""
    objPathFile =Obj3D, "Humans", "Blendswap-Belly dancer.obj"
    #ignoreTexture = true
    if ignoreTexture:
    	texPathFile =Obj3D, "triangleAndSquare.jpg")
    else:
    	texPathFile =Obj3D, "Humans", "textures", "BODY_WH_BD_N_00.png"
    normalize   = true
]#

proc printAllModels*(models=models) =
    let sepLin = "--------------------------------------------------------------" # '-'.repeat(15) not working
    echo sepLin
    for name, mdl in models.pairs:
        echo $mdl
    echo sepLin

proc printAllModelNames*(models=models) =
    echo "names no sensitive to case"
    for name, mdl in models.pairs:
        echo mdl.name

#==============================================================================

when isMainModule:
    from os import getAppFilename, extractFilename, commandLineParams, sleep
    let appName = extractFilename(getAppFilename())
    echo fmt"Begin test {appName}"

    let params = commandLineParams()
    let nParams = params.len

    let modelName = if nParams >= 1: params[0] else: "cygnex"
    #if modelName.in(models): # OK
    let model = getModel(modelName)
    if model == nil:
        echo fmt"{modelName} not in {models}"
        printAllModelNames()
    else:
      echo model
    echo fmt"End test {appName}"

