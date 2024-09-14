import Foundation
import SwiftUI
import SceneKit

struct Polynomial3DGraphView: View {
    @Environment(\.dismissWindow) var dismiss
    
    var scene: SCNScene {
        let scene = SCNScene()
        
        // Create the x, y, z axes as lines
        let axesNode = SCNNode()
        axesNode.addChildNode(createAxisLine(start: SCNVector3(-10, 0, 0), end: SCNVector3(10, 0, 0), color: .red))  // x-axis
        axesNode.addChildNode(createAxisLine(start: SCNVector3(0, -10, 0), end: SCNVector3(0, 10, 0), color: .green)) // y-axis
        axesNode.addChildNode(createAxisLine(start: SCNVector3(0, 0, -10), end: SCNVector3(0, 0, 10), color: .blue))  // z-axis
        
        // Add axis labels
        axesNode.addChildNode(createAxisLabel(text: "X", position: SCNVector3(11, 0, 0), color: .red))
        axesNode.addChildNode(createAxisLabel(text: "Y", position: SCNVector3(0, 11, 0), color: .green))
        axesNode.addChildNode(createAxisLabel(text: "Z", position: SCNVector3(0, 0, 11), color: .blue))
        
        scene.rootNode.addChildNode(axesNode)
        
        // Plot the graph: z = f(x, y)
        let graphNode = SCNNode()
        for x in stride(from: -10.0, through: 10.0, by: 0.5) {
            for y in stride(from: -10.0, through: 10.0, by: 0.5) {
                let z = polynomial(x, y)
                
                let pointNode = createGraphPoint(position: SCNVector3(x, y, z), color: .yellow)
                graphNode.addChildNode(pointNode)
            }
        }
        
        scene.rootNode.addChildNode(graphNode)
        
        // Add lighting for better visibility
        let light = SCNLight()
        light.type = .omni
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(x: 10, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        return scene
    }
    
    // Define a 3D polynomial function: z = f(x, y)
    func polynomial(_ x: Double, _ y: Double) -> Double {
        // Example polynomial: z = x^2 + y^2 (paraboloid)
        return pow(x, 2) + pow(y, 2)
    }
    
    // Create an axis line
    func createAxisLine(start: SCNVector3, end: SCNVector3, color: UIColor) -> SCNNode {
        let lineGeometry = SCNCylinder(radius: 0.05, height: CGFloat((end - start).length()))
        lineGeometry.firstMaterial?.diffuse.contents = color
        let lineNode = SCNNode(geometry: lineGeometry)
        lineNode.position = (start + end) / 2
        lineNode.look(at: end)
        return lineNode
    }
    
    // Create a graph point (as a sphere)
    func createGraphPoint(position: SCNVector3, color: UIColor) -> SCNNode {
        let sphereGeometry = SCNSphere(radius: 0.1)
        sphereGeometry.firstMaterial?.diffuse.contents = color
        let pointNode = SCNNode(geometry: sphereGeometry)
        pointNode.position = position
        return pointNode
    }
    
    // Create an axis label
    func createAxisLabel(text: String, position: SCNVector3, color: UIColor) -> SCNNode {
        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
        textGeometry.firstMaterial?.diffuse.contents = color
        let textNode = SCNNode(geometry: textGeometry)
        textNode.position = position
        textNode.scale = SCNVector3(0.5, 0.5, 0.5)
        return textNode
    }
    
    var body: some View {
        SceneView(
            scene: scene,
            pointOfView: nil,
            options: [.allowsCameraControl, .autoenablesDefaultLighting],
            preferredFramesPerSecond: 60,
            antialiasingMode: .multisampling4X
        )
        .background(.ultraThinMaterial)
        .edgesIgnoringSafeArea(.all)
    }
}

// Helper extensions
extension SCNVector3 {
    static func +(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
        return SCNVector3(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
    }
    
    static func -(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
        return SCNVector3(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
    }
    
    static func /(lhs: SCNVector3, rhs: Float) -> SCNVector3 {
        return SCNVector3(lhs.x / rhs, lhs.y / rhs, lhs.z / rhs)
    }
    
    func length() -> Float {
        return sqrt(x * x + y * y + z * z)
    }
}
