// Needed for prisma error "TypeError: Do not know how to serialize a BigInt"
BigInt.prototype.toJSON = function() {       
    return this.toString()
}