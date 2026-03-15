// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
import fs from 'fs/promises';
import http from "http";
import * as vscode from 'vscode';

const SERVER_PORT = 25822;
const HOST_NAME = "localhost";

let server: http.Server | null;
export function activate(context: vscode.ExtensionContext) {
	const launchServerCommand = vscode.commands.registerCommand("roblox-vscode-integration.launchServer", () => {
		if (server) {
			vscode.window.showInformationMessage(`Server is running`);
			return;
		}
		const workspaceRoot = vscode.workspace.workspaceFolders?.[0]?.uri.fsPath;
		if (!workspaceRoot) {
			vscode.window.showInformationMessage(`No folder opened`);
			return;
		}
		server = http.createServer((req, res) => {
			if (req.url === "/readfile") {
				let path = workspaceRoot;
				req.on("data", (chunk) => {
					path += chunk;
				});
				req.on("end", async () => {
					try {
						const contents = await fs.readFile(path, "utf8");
						res.writeHead(200, {
							"content-type": "text/plain"
						});
						res.end(contents);
					} catch (exception) {
						res.writeHead(400, {
							"content-type": "text/plain"
						});
						res.end(String(exception));
					}
				});
			} else if (req.url === "/writefile") {
				let data = "";
				req.on("data", (chunk) => {
					data += chunk;
				});
				req.on("end", async () => {
					try {
						const parsed = JSON.parse(data);
						await fs.writeFile(workspaceRoot + parsed.path, parsed.contents, "utf8");
						res.writeHead(200, {
							"content-type": "text/plain"
						});
						res.end();
					} catch (exception) {
						res.writeHead(400, {
							"content-type": "text/plain"
						});
						res.end(String(exception));
					}
				});
			} else if (req.url === "/listfiles") {
				let path = workspaceRoot;
				req.on("data", (chunk) => {
					path += chunk;
				});
				req.on("end", async () => {
					try {
						const dir = await fs.opendir(path);
						const paths = [];
						for await (const dirent of dir) {
							paths.push(dirent.name);
						}
						res.writeHead(200, {
							"content-type": "application/json"
						});
						res.end(JSON.stringify(paths));
					} catch (exception) {
						res.writeHead(400, {
							"content-type": "text/plain"
						});
						res.end(String(exception));
					}
				});
			} else if (req.url === "/isfile") {
				let path = workspaceRoot;
				req.on("data", (chunk) => {
					path += chunk;
				});
				req.on("end", async () => {
					try {
						const stat = await fs.stat(path);
						res.writeHead(200, {
							"content-type": "text/plain"
						});
						res.end(String(stat.isFile()));
					} catch (_) {
						res.writeHead(200, {
							"content-type": "text/plain"
						});
						res.end("false");
					}
				});
			} else if (req.url === "/isfolder") {
				let path = workspaceRoot;
				req.on("data", (chunk) => {
					path += chunk;
				});
				req.on("end", async () => {
					try {
						await fs.opendir(path);
						res.writeHead(200, {
							"content-type": "text/plain"
						});
						res.end("true");
					} catch (_) {
						res.writeHead(200, {
							"content-type": "text/plain"
						});
						res.end("false");
					}
				});
			}
			else {
				res.writeHead(400, {
					"content-type": "text/plain"
				});
				res.end("idk");
			}
		});
		server.listen(SERVER_PORT, HOST_NAME, () => {
			vscode.window.showInformationMessage(`Server running on http://${HOST_NAME}:${SERVER_PORT}`);
		});
	});
	context.subscriptions.push(launchServerCommand);

	const closeServerCommand = vscode.commands.registerCommand("roblox-vscode-integration.closeServer", () => {
		if (!server) {
			vscode.window.showInformationMessage(`Server is not running`);
			return;
		}

		server.closeAllConnections();
		server.close();
		server = null;

		vscode.window.showInformationMessage(`Closed server`);
	});
	context.subscriptions.push(closeServerCommand);
}

// This method is called when your extension is deactivated
export function deactivate() {
	if (server) {
		server.closeAllConnections();
		server.close();
		server = null;
	}
}
