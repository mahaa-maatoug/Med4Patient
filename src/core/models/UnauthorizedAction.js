"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.UnAuthorizedAction = UnAuthorizedAction;
function UnAuthorizedAction(res) {
    return res.status(401).send({
        message: "You are not authorized to perform this action"
    });
}
//# sourceMappingURL=UnauthorizedAction.js.map